import 'dart:async';

import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/state/user_state.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

class LoadUser extends Command {
  LoadUser({
    required UserStore userStore,
    required UserRepository userRepository,
  }) : _userStore = userStore,
       _userRepository = userRepository;

  final UserStore _userStore;
  final UserRepository _userRepository;

  StreamSubscription? _subscription;

  void call() async {
    loading();
    _subscription = _userRepository.currentStatus.listen(
      (status) async {
        if (status == UserStatus.unauthenticated) {
          _userStore.userLoggedOut();
          return;
        }

        final result = await _userRepository.currentUser;
        if (result case Ok(:final value)) {
          _userStore.userLoaded(value);
        }

        done();
      },
      onError: setError,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
