import 'package:nice/features/auth/data/user_model.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  final bool isNewUser;

  const AuthAuthenticated({
    required this.user,
    this.isNewUser = false,
  });
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

// OTP specific states
class OtpSent extends AuthState {
  final String email;
  final DateTime sentAt;

  const OtpSent({
    required this.email,
    required this.sentAt,
  });
}

class OtpVerifying extends AuthState {
  const OtpVerifying();
}

class OtpError extends AuthState {
  final String message;
  final int attemptsRemaining;

  const OtpError({
    required this.message,
    required this.attemptsRemaining,
  });
}

class OtpLocked extends AuthState {
  final DateTime lockedUntil;

  const OtpLocked({
    required this.lockedUntil,
  });
}
