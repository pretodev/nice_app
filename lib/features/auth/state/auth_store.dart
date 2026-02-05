import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/shared/state/store.dart';

class AuthStore extends Store<AuthState> {
  AuthStore() : super(const AuthState());

  void otpRequest(OtpCredentials credentials) {
    setState(
      key: 'otpRequest',
      state.copyWith(
        credentials: () => credentials,
      ),
    );
  }

  void clearCredentials() {
    setState(
      key: 'clearCredentials',
      state.copyWith(
        credentials: () => null,
      ),
    );
  }
}

final class AuthState extends Equatable {
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
  List<Object?> get props => [credentials];
}
