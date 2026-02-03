import 'package:nice/features/auth/data/auth_data_provider.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_credentials_command.g.dart';

@riverpod
class LoadCredentialsCommand extends _$LoadCredentialsCommand
    with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  void call() async {
    emitLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final authStore = ref.read(authStoreProvider.notifier);

    final result = await authRepo.getOtpCredentials();

    if (result case Some(:final value)) {
      authStore.emit(OtpRequest(value));
    }
    emitOk();
  }
}
