import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/providers/provider_services.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_profile_data_command.g.dart';

@riverpod
class SetProfileDataCommand extends _$SetProfileDataCommand with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  Future<void> call(
    UserEntity user, {
    required String displayName,
  }) async {
    emitLoading();
    user.displayName = displayName;
    final result = await ref.watch(userRepositoryProvider).set(user);
    emitResult(result);
  }
}
