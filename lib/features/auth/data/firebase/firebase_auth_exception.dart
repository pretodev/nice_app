import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/features/auth/data/auth_failures.dart';

extension FirebaseAuthExceptionMapper on FirebaseAuthException {
  AuthFailure toAuthFailure() {
    switch (code) {
      case 'invalid-email':
      case 'user-not-found':
      case 'user-disabled':
        return const InvalidEmailFailure();
      case 'invalid-action-code':
      case 'expired-action-code':
        return const InvalidLinkFailure();
      case 'too-many-requests':
        return const TooManyRequestsFailure();
      case 'network-request-failed':
        return const NetworkFailure();
      default:
        return UnknownAuthFailure(message);
    }
  }
}
