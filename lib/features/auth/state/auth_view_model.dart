import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/core/state/view_model.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/data/email_address.dart';

class AuthViewModel extends ViewModel<AuthState> {
  AuthViewModel(this._authService, this._authRepository)
    : super(const AuthState());

  final AuthService _authService;
  final AuthRepository _authRepository;

  late final sendOtp = _sendOtp.bind();
  late final verifyOtp = _verifyOtp.bind();
  late final cancelOtp = _cancelOtp.bind();
  late final loadCredentials = _loadCredentials.bind();

  FutureResult<Unit> _sendOtp(EmailAddress email) async {
    final credentials = EmailLinkCredentials(email: email);
    return _authService
        .sendSignInLink(email)
        .flatMapAsync((_) => _authRepository.store(credentials))
        .inspect((_) => emit(state.copyWith(credentials: () => credentials)));
  }

  FutureResult<Unit> _verifyOtp(String emailLink) async {
    if (!_authService.isSignInLink(emailLink)) {
      return const Err(InvalidLinkFailure());
    }

    final credentialsResult = await _authRepository.getEmailLinkCredentials();

    if (credentialsResult case None()) {
      emit(state.copyWith(credentials: () => null));
      return const Err(
        UnknownAuthFailure(
          'Sign-in link not associated with any pending email. '
          'Please request a new link.',
        ),
      );
    }

    final Some(:value) = credentialsResult as Some<EmailLinkCredentials>;
    final result = await _authService.signInWithLink(
      email: value.email,
      emailLink: emailLink,
    );

    if (result case Err()) return result;

    await _authRepository.deleteCredentials();
    emit(state.copyWith(credentials: () => null));
    return ok;
  }

  FutureResult<Unit> _cancelOtp() async {
    final result = await _authRepository.deleteCredentials();
    if (result.isOk) {
      emit(state.copyWith(credentials: () => null));
    }
    return result;
  }

  FutureResult<Unit> _loadCredentials() async {
    final result = await _authRepository.getEmailLinkCredentials();
    if (result case Some(:final value)) {
      emit(state.copyWith(credentials: () => value));
    }
    return ok;
  }
}

final class AuthState extends Equatable {
  final AuthCredentials? credentials;

  const AuthState({this.credentials});

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
