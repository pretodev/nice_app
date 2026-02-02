import 'dart:async';

import 'package:nice/features/user/data/user_data_provider.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/state/user_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_user_command.g.dart';

@riverpod
class LoadUserCommand extends _$LoadUserCommand with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  StreamSubscription? _subscription;

  void call() async {
    emitLoading();
    ref.onDispose(() => _subscription?.cancel());
    final userRepo = ref.read(userRepositoryProvider);
    final userStore = ref.read(userStoreProvider.notifier);

    _subscription = userRepo.currentStatus.listen((status) async {
      if (status == UserStatus.unauthenticated) {
        userStore.emit(const UserSignOut());
        emitOk();
        return;
      }

      final result = await userRepo.currentUser.map(
        (user) => userStore.emit(UserLoaded(user)),
      );

      emitResult(result);
    });
  }
}
