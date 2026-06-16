import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/user/data/user_failures.dart';
import 'package:nice/features/user/data/user_id.dart';
import 'package:nice/features/user/data/user_status.dart';

class AuthService({
  required final FirebaseAuth _auth,
}) {
  FutureResult<Unit> signInAnonymously() async {
    if (_auth.currentUser != null) return ok;
    try {
      await _auth.signInAnonymously();
      return ok;
    } on FirebaseAuthException catch (e, s) {
      return Err(
        AnonymousSignInFailure(debugDetails: e.message, stackTrace: s),
        s,
      );
    }
  }

  FutureResult<UserId> get currentUser async {
    return _auth.currentUser != null
        ? Ok(UserId(_auth.currentUser!.uid))
        : const Err(UserNotAuthenticated());
  }

  Stream<UserStatus> get currentStatus {
    return _auth.authStateChanges().map(
      (user) =>
          user != null ? UserStatus.authenticated : UserStatus.unauthenticated,
    );
  }

  FutureResult<Unit> signOut() async {
    await _auth.signOut();
    return ok;
  }
}
