import 'package:nice/features/user/data/user_data_provider.dart';
import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/state/user_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_profile_data_command.g.dart';

@riverpod
class SetProfileData extends _$SetProfileData with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  void call(
    UserEntity user, {
    required String displayName,
  }) async {
    emitLoading();
    final userRepo = ref.read(userRepositoryProvider);
    final userStore = ref.read(userStoreProvider.notifier);

    user.displayName = displayName;
    final result = await userRepo.set(user);
    switch (result) {
      case Ok():
        userStore.emit(UserProfileUpdated(user));
      case Err():
        return emitError(result.value);
    }
    emitOk();
  }
}
