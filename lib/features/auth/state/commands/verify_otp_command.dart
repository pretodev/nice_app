import 'package:nice/features/auth/data/auth_data_provider.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verify_otp_command.g.dart';

@riverpod
class VerifyOtp extends _$VerifyOtp with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  /// Verifica o código OTP
  /// Usa o otpId armazenado em SharedPreferences
  void call(String otp) async {
    emitLoading();
    final authService = ref.read(authServiceProvider);
    final authRepo = ref.read(authRepositoryProvider);
    final authStore = ref.read(authStoreProvider.notifier);

    final otpIdResult = await authRepo.getOtpCredentials();

    if (otpIdResult case None()) {
      emitError(
        const UnknownAuthFailure(
          'OTP code not valid. Please check the code and try again.',
        ),
      );
      authStore.emit(const ClearCredentials());
      return;
    }

    if (otpIdResult case Some(:final value)) {
      final result = await authService
          .verifyOtp(otpId: value.otpId, otp: otp)
          .flatMapAsync((_) => authRepo.deleteCredentials())
          .map((unit) => authStore.emit(const ClearCredentials()));
      emitResult(result);
    }
  }
}
