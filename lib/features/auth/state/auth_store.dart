import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_store.g.dart';

@riverpod
class AuthStore extends _$AuthStore {
  @override
  AuthState build() {
    return const AuthState();
  }

  void emit(AuthEvent event) {
    state = switch (event) {
      OtpRequest(:final credentials) => state.copyWith(
        credentials: () => credentials,
      ),
      ClearCredentials() => state.copyWith(
        credentials: () => null,
      ),
    };
  }
}

@immutable
class AuthState {
  final AuthCredentials? credentials;

  const AuthState({
    this.credentials,
  });

  AuthState copyWith({
    ValueGetter<AuthCredentials?>? credentials,
  }) {
    return AuthState(
      credentials: credentials != null ? credentials() : this.credentials,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState && other.credentials == credentials;
  }

  @override
  int get hashCode => credentials.hashCode;
}

sealed class AuthEvent {
  const AuthEvent();
}

class OtpRequest extends AuthEvent {
  const OtpRequest(this.credentials);

  final OtpCredentials credentials;
}

class ClearCredentials extends AuthEvent {
  const ClearCredentials();
}
