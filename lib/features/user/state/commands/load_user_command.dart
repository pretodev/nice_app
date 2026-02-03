import 'dart:async';

import 'package:nice/features/user/data/user_data_provider.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/state/user_store.dart';
import 'package:nice/shared/data/shared_data_provider.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_user_command.g.dart';

@Riverpod(keepAlive: true)
class LoadUserCommand extends _$LoadUserCommand with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  StreamSubscription? _subscription;

  void call() async {
    emitLoading();
    ref.onDispose(() => _subscription?.cancel());

    final pb = ref.read(pocketbaseClientProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final userStore = ref.read(userStoreProvider.notifier);

    // Check for existing valid session on startup to refresh token if needed
    if (pb.authStore.isValid) {
      try {
        await pb.collection('users').authRefresh();
      } catch (_) {
        // If refresh fails, authStore is usually cleared automatically or should be cleared
        pb.authStore.clear();
      }
    }

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
