import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/features/user/state/user_state.dart';
import 'package:nice/shared/state/command.dart';

class SignOut extends Command {
  SignOut({
    required this._userRepository,
    required this._userStore,
  });

  final UserStore _userStore;
  final UserRepository _userRepository;

  void call() async {
    loading();
    final result = await _userRepository.signOut();
    switch (result) {
      case Ok():
        _userStore.userLoggedOut();
      case Err(:final failure):
        return setError(failure);
    }
    return done();
  }
}
