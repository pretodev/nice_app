import 'package:nice/features/auth/providers/provider_services.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cancel_otp_command.g.dart';

@riverpod
class CancelOtp extends _$CancelOtp with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() => invalidState();

  /// Cancela a verificação do OTP
  Future<void> call() async {
    emitLoading();
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.deleteCredentials();
    emitResult(result);
  }
}
