sealed class AuthFailure implements Exception {
  const AuthFailure();

  String get message;
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure();

  @override
  String get message => 'Invalid email format';
}

class EmailNotSentFailure extends AuthFailure {
  const EmailNotSentFailure([this.reason]);

  final String? reason;

  @override
  String get message => reason ?? 'Failed to send email link';
}

class InvalidLinkFailure extends AuthFailure {
  const InvalidLinkFailure();

  @override
  String get message => 'Invalid or expired sign-in link';
}

class InvalidOtpFailure extends AuthFailure {
  const InvalidOtpFailure();

  @override
  String get message => 'Invalid OTP code';
}

class ExpiredOtpFailure extends AuthFailure {
  const ExpiredOtpFailure();

  @override
  String get message => 'OTP code has expired';
}

class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure();

  @override
  String get message => 'Too many requests. Please try again later';
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure();

  @override
  String get message => 'Network error. Please check your connection';
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([this.reason]);

  final String? reason;

  @override
  String get message => reason ?? 'An unknown error occurred';
}
