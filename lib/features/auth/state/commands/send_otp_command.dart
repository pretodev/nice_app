import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_data_provider.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_otp_command.g.dart';

@riverpod
class SendOtp extends _$SendOtp with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  void call(EmailAddress email) async {
    emitLoading();
    final authService = ref.read(authServiceProvider);
    final authRepo = ref.read(authRepositoryProvider);
    final authStore = ref.read(authStoreProvider.notifier);

    OtpCredentials? otpCredentials;

    final result = await authService
        .sendOtp(email)
        .flatMapAsync(
          (optId) {
            otpCredentials = OtpCredentials(email: email, otpId: optId);
            return authRepo.store(otpCredentials!);
          },
        )
        .map((_) {
          authStore.emit(OtpRequest(otpCredentials!));
          return otpCredentials!;
        });

    emitResult(result);
  }
}
