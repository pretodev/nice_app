import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nice/features/auth/data/user_model.dart';
import 'package:nice/features/auth/data/rate_limit_service.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final RateLimitService _rateLimitService;
  final SharedPreferences _prefs;

  static const String _emailKey = 'pending_email';
  static const String _otpSentAtKey = 'otp_sent_at';
  static const String _verificationIdKey = 'verification_id';
  static const Duration otpValidityDuration = Duration(minutes: 10);

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    required RateLimitService rateLimitService,
    required SharedPreferences prefs,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _rateLimitService = rateLimitService,
        _prefs = prefs {
    _auth.setSettings(appVerificationDisabledForTesting: false);
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Save email for OTP flow
  Future<void> _saveEmail(String email) async {
    await _prefs.setString(_emailKey, email);
  }

  String? getSavedEmail() {
    return _prefs.getString(_emailKey);
  }

  Future<void> _clearSavedEmail() async {
    await _prefs.remove(_emailKey);
  }

  // OTP timestamp management
  Future<void> _saveOtpSentAt() async {
    await _prefs.setString(_otpSentAtKey, DateTime.now().toIso8601String());
  }

  DateTime? getOtpSentAt() {
    final sentAtStr = _prefs.getString(_otpSentAtKey);
    return sentAtStr != null ? DateTime.parse(sentAtStr) : null;
  }

  bool isOtpExpired() {
    final sentAt = getOtpSentAt();
    if (sentAt == null) return true;
    return DateTime.now().difference(sentAt) > otpValidityDuration;
  }

  // Send OTP via Firebase Auth email link
  // Note: Firebase will send an email with a link that contains the verification code
  // The user can either click the link or copy the OTP from the email
  Future<void> sendOtp(String email) async {
    // Check rate limits
    if (_rateLimitService.isLocked()) {
      throw Exception('Muitas tentativas. Aguarde 1 hora para tentar novamente.');
    }

    if (await _rateLimitService.isRequestLimitExceeded()) {
      await _rateLimitService.setLockout();
      throw Exception('Muitas tentativas. Aguarde 1 hora para tentar novamente.');
    }

    try {
      // Save email and track request
      await _saveEmail(email);
      await _rateLimitService.addRequestTime();
      await _rateLimitService.resetAttemptCount();
      await _saveOtpSentAt();

      // Configure action code settings for email link
      // The email template should be customized in Firebase Console to show a 6-digit code
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://niceapp.page.link/verify?email=$email',
        handleCodeInApp: true,
        androidPackageName: 'com.pretodev.nice',
        androidInstallApp: true,
        androidMinimumVersion: '1',
        iOSBundleId: 'com.pretodev.nice',
      );

      // Send sign-in email link
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP code
  // The OTP is extracted from the email link sent by Firebase
  Future<UserModel> verifyOtp(String email, String otp) async {
    // Check if locked
    if (_rateLimitService.isLocked()) {
      throw Exception('Muitas tentativas. Aguarde 1 hora para tentar novamente.');
    }

    // Check attempt limit
    if (_rateLimitService.isAttemptLimitExceeded()) {
      throw Exception('Limite de tentativas excedido. Solicite um novo código.');
    }

    // Check if expired
    if (isOtpExpired()) {
      throw Exception('Código expirado. Solicite um novo código.');
    }

    try {
      // Increment attempt count
      await _rateLimitService.incrementAttemptCount();

      // Build the email link with OTP
      // In production, the link structure should match what Firebase sends
      final emailLink = 'https://niceapp.page.link/verify?email=$email&otp=$otp';
      
      // Verify if it's a valid sign-in link
      if (_auth.isSignInWithEmailLink(emailLink)) {
        // Sign in with email link
        final credential = await _auth.signInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );

        if (credential.user == null) {
          throw Exception('Código inválido. Tente novamente.');
        }

        // Check if new user
        final isNewUser = credential.additionalUserInfo?.isNewUser ?? false;

        // Create or get user data
        final user = await _getUserModel(credential.user!, isNewUser);

        // Clear saved data
        await _clearSavedEmail();
        await _rateLimitService.resetAll();

        return user;
      } else {
        throw Exception('Código inválido. Tente novamente.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code' || e.code == 'expired-action-code') {
        throw Exception('Código inválido ou expirado.');
      }
      throw Exception('Código inválido. Tente novamente.');
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Código inválido. Tente novamente.');
    }
  }

  // Get or create user model
  Future<UserModel> _getUserModel(User firebaseUser, bool isNewUser) async {
    final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
    
    if (isNewUser) {
      // Create new user document
      final userData = {
        'uid': firebaseUser.uid,
        'email': firebaseUser.email!,
        'displayName': firebaseUser.displayName,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await userDoc.set(userData);
    }

    // Fetch user data
    final snapshot = await userDoc.get();
    final data = snapshot.data();

    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: data?['displayName'] as String?,
      createdAt: data?['createdAt'] != null
          ? (data!['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String displayName,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await user.updateDisplayName(displayName);
    await _firestore.collection('users').doc(user.uid).update({
      'displayName': displayName,
    });
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _clearSavedEmail();
    await _rateLimitService.resetAll();
  }

  // Check if user needs profile completion
  bool needsProfileCompletion() {
    final user = currentUser;
    if (user == null) return false;
    return user.displayName == null || user.displayName!.isEmpty;
  }

  // Get remaining attempts for OTP verification
  int getRemainingAttempts() {
    return _rateLimitService.getRemainingAttempts();
  }

  // Check if currently locked
  bool isLocked() {
    return _rateLimitService.isLocked();
  }

  // Get locked until time
  DateTime? getLockedUntil() {
    return _rateLimitService.getLockedUntil();
  }
}
