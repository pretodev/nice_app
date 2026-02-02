import 'package:nice/features/user/data/user_data_provider.dart';
import 'package:nice/features/user/state/user_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_command.g.dart';

@riverpod
class SignOut extends _$SignOut with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  Future<void> call() async {
    emitLoading();
    final userRepo = ref.read(userRepositoryProvider);
    final userStore = ref.read(userStoreProvider.notifier);

    final result = await userRepo.signOut();
    switch (result) {
      case Ok():
        userStore.emit(const UserSignOut());
      case Err():
        return emitError(result.value);
    }
    return emitOk();
  }
}
