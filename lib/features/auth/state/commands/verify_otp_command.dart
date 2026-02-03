import 'package:nice/features/auth/data/auth_data_provider.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/features/user/data/user_data_provider.dart';
import 'package:nice/features/user/state/user_store.dart';
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
    final userRepo = ref.read(userRepositoryProvider);
    final userStore = ref.read(userStoreProvider.notifier);

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
      final verifyResult = await authService.verifyOtp(
        otpId: value.otpId,
        otp: otp,
      );

      if (verifyResult case Err()) {
        emitResult(verifyResult);
        return;
      }

      // Carrega o usuário imediatamente após sucesso para garantir estado autenticado
      final userResult = await userRepo.currentUser;

      if (userResult case Ok(:final value)) {
        userStore.emit(UserLoaded(value));

        await authRepo.deleteCredentials();
        authStore.emit(const ClearCredentials());
        emitOk();
      } else {
        // Se falhar ao carregar usuário, emite erro
        emitResult(userResult.map((_) => unit));
      }
    }
  }
}
