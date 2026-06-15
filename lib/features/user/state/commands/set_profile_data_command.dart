import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/features/user/state/user_state.dart';
import 'package:nice/shared/state/command.dart';

class SetProfileData extends Command {
  SetProfileData({
    required this._userRepository,
    required this._userStore,
  });

  final UserStore _userStore;

  final UserRepository _userRepository;

  void call(
    UserEntity user, {
    required String displayName,
  }) async {
    loading();
    user.displayName = displayName;
    final result = await _userRepository.set(user);
    switch (result) {
      case Ok():
        _userStore.userUpdated(user);
      case Err(:final failure):
        return setError(failure);
    }
    done();
  }
}
