import 'package:nice/features/auth/data/email_address.dart';

sealed class AuthCredentials {
  const AuthCredentials();
}

class OtpCredentials extends AuthCredentials {
  const OtpCredentials({
    required this.email,
    required this.otpId,
  });

  final EmailAddress email;

  final String otpId;
}
