import 'package:flutter/widgets.dart';
import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_store.g.dart';

@riverpod
class UserStore extends _$UserStore {
  @override
  UserState build() {
    return const UserState();
  }

  void emit(UserEvent event) {
    state = switch (event) {
      UserLoaded(:final user) => state.copyWith(
        user: () => user,
        status: UserStatus.authenticated,
      ),
      UserSignOut() => state.copyWith(
        user: () => null,
        status: UserStatus.unauthenticated,
      ),
      UserProfileUpdated(:final user) => state.copyWith(
        user: () => user,
      ),
    };
  }
}

@immutable
class UserState {
  final UserEntity? user;
  final UserStatus status;

  const UserState({
    this.user,
    this.status = UserStatus.waiting,
  });

  UserState copyWith({
    ValueGetter<UserEntity?>? user,
    UserStatus? status,
  }) {
    return UserState(
      user: user != null ? user() : this.user,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserState && other.user == user && other.status == status;
  }

  @override
  int get hashCode => user.hashCode ^ status.hashCode;
}

sealed class UserEvent {
  const UserEvent();
}

class UserLoaded extends UserEvent {
  const UserLoaded(this.user);

  final UserEntity user;
}

class UserSignOut extends UserEvent {
  const UserSignOut();
}

class UserProfileUpdated extends UserEvent {
  const UserProfileUpdated(this.user);

  final UserEntity user;
}
