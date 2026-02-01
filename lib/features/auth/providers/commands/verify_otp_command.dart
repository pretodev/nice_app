import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/mixins/command_provider_base_mixin.dart';
import '../../data/auth_failures.dart';
import '../provider_services.dart';

part 'verify_otp_command.g.dart';

@riverpod
class VerifyOtp extends _$VerifyOtp with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() => invalidState();

  /// Verifica o código OTP
  /// Usa o otpId armazenado em SharedPreferences
  Future<void> call(String otp) async {
    emitLoading();
    final authService = ref.read(authServiceProvider);
    final authRepo = ref.read(authRepositoryProvider);
    final otpIdResult = await authRepo.getOtpCredentials();
    if (otpIdResult case None()) {
      emitResult(
        const Err<Unit>(
          UnknownAuthFailure('OTP session expired. Please request a new code.'),
        ),
      );
      return;
    }
    if (otpIdResult case Some(:final value)) {
      final result = await authService
          .verifyOtp(otpId: value.otpId, otp: otp)
          .flatMapAsync((_) => authRepo.deleteCredentials());
      emitResult(result);
    }
  }
}
