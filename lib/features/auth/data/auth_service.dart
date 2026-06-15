import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/data/firebase/firebase_auth_exception.dart';
import 'package:nice/shared/environment.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  ActionCodeSettings get _actionCodeSettings => ActionCodeSettings(
    url: Environment.emailLinkContinueUrl,
    handleCodeInApp: true,
    androidPackageName: Environment.emailLinkAndroidPackageName,
    androidInstallApp: true,
    iOSBundleId: Environment.emailLinkIosBundleId,
  );

  /// Dispara o envio de um sign-in link para o email informado.
  FutureResult<Unit> sendSignInLink(EmailAddress email) async {
    try {
      await _auth.sendSignInLinkToEmail(
        email: email.value,
        actionCodeSettings: _actionCodeSettings,
      );
      return ok;
    } on FirebaseAuthException catch (e, s) {
      return Err(e.toAuthFailure(), s);
    }
  }

  /// Verifica se a string informada corresponde a um link válido de sign-in.
  bool isSignInLink(String link) => _auth.isSignInWithEmailLink(link);

  /// Conclui o sign-in usando o link recebido por email.
  FutureResult<Unit> signInWithLink({
    required EmailAddress email,
    required String emailLink,
  }) async {
    try {
      await _auth.signInWithEmailLink(
        email: email.value,
        emailLink: emailLink,
      );
      return ok;
    } on FirebaseAuthException catch (e, s) {
      return Err(e.toAuthFailure(), s);
    }
  }
}
