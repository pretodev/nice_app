import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:nice/features/auth/data/auth_state.dart';
import 'package:nice/features/auth/data/firebase/firebase_exception.dart';
import 'package:odu_core/odu_core.dart';

import 'auth_failures.dart';
import 'email_address.dart';

class AuthService {
  final _firebaseAuth = fb.FirebaseAuth.instance;

  static final _actionCodeSettings = fb.ActionCodeSettings(
    url: 'https://valney-fitness.firebaseapp.com/__/auth/action',
    handleCodeInApp: true,
    androidPackageName: 'br.com.odulab.nice',
    androidInstallApp: true,
    androidMinimumVersion: '21',
    iOSBundleId: 'br.com.odulab.nice',
  );

  FutureResult<Unit> sendSignInLink(EmailAddress email) async {
    try {
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email.value,
        actionCodeSettings: _actionCodeSettings,
      );
      return ok;
    } on fb.FirebaseAuthException catch (e, s) {
      return Err(e.toFailure(), s);
    }
  }

  FutureResult<Unit> signInWithEmailLink({
    required String email,
    required String link,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailLink(
        email: email,
        emailLink: link,
      );
      if (credential.user == null) {
        return const Err(UnknownAuthFailure('User is null after sign-in'));
      }
      return ok;
    } on fb.FirebaseAuthException catch (e, s) {
      return Err(e.toFailure(), s);
    }
  }

  bool isSignInWithEmailLink(String link) {
    return _firebaseAuth.isSignInWithEmailLink(link);
  }

  Stream<AuthState> get state {
    return _firebaseAuth.authStateChanges().map(
      (user) => user == null ? const Unauthenticated() : const Authenticated(),
    );
  }

  FutureResult<Unit> signOut() async {
    await _firebaseAuth.signOut();
    return ok;
  }
}
