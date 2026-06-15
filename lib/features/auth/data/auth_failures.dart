import 'package:nice/core/fp/fp.dart';

sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('Invalid email format');
}

class EmailNotSentFailure extends AuthFailure {
  const EmailNotSentFailure([String? reason])
    : super(reason ?? 'Failed to send email link');
}

class InvalidLinkFailure extends AuthFailure {
  const InvalidLinkFailure() : super('Invalid or expired sign-in link');
}

class InvalidOtpFailure extends AuthFailure {
  const InvalidOtpFailure() : super('Invalid OTP code');
}

class ExpiredOtpFailure extends AuthFailure {
  const ExpiredOtpFailure() : super('OTP code has expired');
}

class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure()
    : super('Too many requests. Please try again later');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure() : super('Network error. Please check your connection');
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([String? reason])
    : super(reason ?? 'An unknown error occurred');
}
