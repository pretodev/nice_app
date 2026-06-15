import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/state/command.dart';

/// Envia o sign-in link (Firebase Email Link) para o email informado.
class SendOtp extends Command {
  final AuthService _authService;
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  SendOtp({
    required this._authService,
    required this._authRepository,
    required this._authStore,
  });

  void call(EmailAddress email) async {
    loading();

    final credentials = EmailLinkCredentials(email: email);

    final result = await _authService
        .sendSignInLink(email)
        .flatMapAsync((_) => _authRepository.store(credentials))
        .map((_) {
          _authStore.emailLinkRequest(credentials);
        });

    if (result case Err(:final failure)) {
      return setError(failure);
    }

    done();
  }
}
