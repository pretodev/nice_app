import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/state/command.dart';

/// Conclui o sign-in com o link enviado por email.
class VerifyOtp extends Command {
  final AuthService _authService;
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  VerifyOtp({
    required this._authService,
    required this._authRepository,
    required this._authStore,
  });

  /// Recebe o link de sign-in que o usuário clicou (deep link).
  void call(String emailLink) async {
    loading();

    if (!_authService.isSignInLink(emailLink)) {
      setError(const InvalidLinkFailure());
      return;
    }

    final credentialsResult = await _authRepository.getEmailLinkCredentials();

    if (credentialsResult case None()) {
      _authStore.clearCredentials();
      setError(
        const UnknownAuthFailure(
          'Sign-in link not associated with any pending email. '
          'Please request a new link.',
        ),
      );
      return;
    }

    if (credentialsResult case Some(:final value)) {
      final result = await _authService.signInWithLink(
        email: value.email,
        emailLink: emailLink,
      );

      if (result case Err(:final failure)) {
        setError(failure);
        return;
      }
      await _authRepository.deleteCredentials();
      _authStore.clearCredentials();
    }

    done();
  }
}
