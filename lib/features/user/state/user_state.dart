import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/shared/state/store.dart';

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

class UserStore extends Store<UserState> {
  UserStore() : super(const UserState());

  void userLoaded(UserEntity user) {
    setState(
      key: 'userLoaded',
      value.copyWith(user: () => user, status: UserStatus.authenticated),
    );
  }

  void userLoggedOut() {
    setState(
      key: 'userLoggedOut',
      value.copyWith(
        status: UserStatus.unauthenticated,
        user: () => null,
      ),
    );
  }

  void userUpdated(UserEntity user) {
    setState(
      key: 'userUpdated',
      value.copyWith(user: () => user),
    );
  }
}
