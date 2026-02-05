import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

class VerifyOtp extends Command {
  final AuthService _authService;
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  VerifyOtp({
    required AuthService authService,
    required AuthRepository authRepository,
    required AuthStore authStore,
  }) : _authService = authService,
       _authRepository = authRepository,
       _authStore = authStore;

  /// Verifica o código OTP
  /// Usa o otpId armazenado em SharedPreferences
  void call(String otp) async {
    loading();

    final otpIdResult = await _authRepository.getOtpCredentials();

    if (otpIdResult case None()) {
      _authStore.clearCredentials();
      setError(
        const UnknownAuthFailure(
          'OTP code not valid. Please check the code and try again.',
        ),
      );
      return;
    }

    if (otpIdResult case Some(:final value)) {
      final verifyResult = await _authService.verifyOtp(
        otpId: value.otpId,
        otp: otp,
      );

      if (verifyResult case Err()) {
        setError(verifyResult.value);
        return;
      }
      _authStore.clearCredentials();
    }

    done();
  }
}
