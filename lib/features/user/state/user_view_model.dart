import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/core/state/view_model.dart';
import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/features/user/data/user_status.dart';

class UserViewModel extends ViewModel<UserState> {
  UserViewModel(this._userRepository) : super(const UserState());

  final UserRepository _userRepository;

  StreamSubscription? _statusSubscription;

  late final setProfileData = _setProfileData.bind();
  late final signOut = _signOut.bind();

  void loadUser() {
    _statusSubscription?.cancel();
    _statusSubscription = _userRepository.currentStatus.listen((status) async {
      if (status == UserStatus.unauthenticated) {
        emit(
          state.copyWith(user: () => null, status: UserStatus.unauthenticated),
        );
        return;
      }

      final result = await _userRepository.currentUser;
      if (result case Ok(:final value)) {
        emit(
          state.copyWith(
            user: () => value,
            status: UserStatus.authenticated,
          ),
        );
      }
    });
  }

  FutureResult<Unit> _setProfileData(
    UserEntity user,
    String displayName,
  ) async {
    user.displayName = displayName;
    final result = await _userRepository.set(user);
    if (result.isOk) {
      emit(state.copyWith(user: () => user));
    }
    return result;
  }

  FutureResult<Unit> _signOut() async {
    final result = await _userRepository.signOut();
    if (result.isOk) {
      emit(
        state.copyWith(
          user: () => null,
          status: UserStatus.unauthenticated,
        ),
      );
    }
    return result;
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}

final class UserState extends Equatable {
  final UserEntity? user;
  final UserStatus status;

  const UserState({
    this.user,
    this.status = UserStatus.waiting,
  });

  @override
  final stringify = true;

  @override
  List<Object?> get props => [user, status];

  UserState copyWith({
    ValueGetter<UserEntity?>? user,
    UserStatus? status,
  }) {
    return UserState(
      user: user != null ? user() : this.user,
      status: status ?? this.status,
    );
  }
}
