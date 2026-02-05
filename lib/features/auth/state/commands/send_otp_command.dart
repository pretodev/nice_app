import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

class SendOtp extends Command {
  final AuthService _authService;
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  SendOtp({
    required AuthService authService,
    required AuthRepository authRepository,
    required AuthStore authStore,
  }) : _authService = authService,
       _authRepository = authRepository,
       _authStore = authStore;

  void call(EmailAddress email) async {
    loading();

    OtpCredentials? otpCredentials;

    final result = await _authService
        .sendOtp(email)
        .flatMapAsync(
          (optId) {
            otpCredentials = OtpCredentials(email: email, otpId: optId);
            return _authRepository.store(otpCredentials!);
          },
        )
        .map((_) {
          _authStore.otpRequest(otpCredentials!);
        });

    if (result case Err(:final value)) {
      return setError(value);
    }

    done();
  }
}
