import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/core/state/view_model.dart';
import 'package:nice/features/user/data/auth_service.dart';
import 'package:nice/features/user/data/user_id.dart';
import 'package:nice/features/user/data/user_status.dart';

class UserViewModel extends ViewModel<UserState> {
  UserViewModel({
    required this._userRepository,
  }) : super(const UserNone());

  final AuthService _userRepository;

  StreamSubscription? _statusSubscription;

  late final signOut = _signOut.bind();

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  void loadUser() {
    _statusSubscription?.cancel();
    _statusSubscription = _userRepository.currentStatus.listen((status) async {
      if (status == UserStatus.unauthenticated) {
        final result = await _userRepository.signInAnonymously();
        if (result case Err()) {
          emit(const UserUnauthenticated());
        }
        return;
      }

      final result = await _userRepository.currentUser;
      if (result case Ok(value: final userId)) {
        emit(UserAuthenticated(userId: userId));
      }
    });
  }

  FutureResult<Unit> _signOut() async {
    final result = await _userRepository.signOut();
    if (result.isOk) {
      emit(const UserUnauthenticated());
    }
    return result;
  }
}

sealed class const UserState() extends Equatable;

final class const UserNone() extends UserState {
  @override
  List<Object?> get props => [];
}

final class const UserAuthenticated({required final UserId userId})
    extends UserState {
  @override
  List<Object?> get props => [userId];
}

final class const UserUnauthenticated() extends UserState {
  @override
  List<Object?> get props => [];
}
