import 'package:nice/features/auth/data/auth_data_provider.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cancel_otp_command.g.dart';

@riverpod
class CancelOtp extends _$CancelOtp with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  /// Cancela a verificação do OTP
  void call() async {
    emitLoading();
    final authRepo = ref.read(authRepositoryProvider);
    final authStore = ref.read(authStoreProvider.notifier);
    final result = await authRepo.deleteCredentials().map(
      (unit) => authStore.emit(const ClearCredentials()),
    );
    emitResult(result);
  }
}
