import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/data/auth_state.dart';
import 'package:nice/features/auth/data/rate_limit_service.dart';

// Shared Preferences Provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Rate Limit Service Provider
final rateLimitServiceProvider = Provider<RateLimitService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return RateLimitService(prefs);
});

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  final rateLimitService = ref.watch(rateLimitServiceProvider);
  
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  
  return AuthService(
    rateLimitService: rateLimitService,
    prefs: prefs,
  );
});

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

// Auth Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AuthInitial()) {
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = _authService.currentUser;
    if (user != null) {
      state = AuthAuthenticated(
        user: _mapFirebaseUser(user),
        isNewUser: false,
      );
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> sendOtp(String email) async {
    state = const AuthLoading();
    
    try {
      await _authService.sendOtp(email);
      state = OtpSent(
        email: email,
        sentAt: DateTime.now(),
      );
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    state = const OtpVerifying();
    
    try {
      final user = await _authService.verifyOtp(email, otp);
      final needsProfile = _authService.needsProfileCompletion();
      
      state = AuthAuthenticated(
        user: user,
        isNewUser: needsProfile,
      );
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      
      if (_authService.isLocked()) {
        final lockedUntil = _authService.getLockedUntil();
        state = OtpLocked(
          lockedUntil: lockedUntil ?? DateTime.now().add(const Duration(hours: 1)),
        );
      } else if (errorMessage.contains('Limite de tentativas excedido')) {
        state = const OtpError(
          message: 'Limite de tentativas excedido. Solicite um novo código.',
          attemptsRemaining: 0,
        );
      } else {
        state = OtpError(
          message: errorMessage,
          attemptsRemaining: _authService.getRemainingAttempts(),
        );
      }
    }
  }

  Future<void> resendOtp(String email) async {
    await sendOtp(email);
  }

  Future<void> updateProfile(String displayName) async {
    state = const AuthLoading();
    
    try {
      await _authService.updateUserProfile(displayName: displayName);
      final user = _authService.currentUser;
      
      if (user != null) {
        state = AuthAuthenticated(
          user: _mapFirebaseUser(user),
          isNewUser: false,
        );
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthUnauthenticated();
  }

  // Helper method to map Firebase User to UserModel
  UserModel _mapFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      createdAt: user.metadata.creationTime,
    );
  }
}
