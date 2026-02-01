import 'package:nice/features/auth/data/email_address.dart';

sealed class AuthCredentials {
  const AuthCredentials();
}

class OtpCredentials extends AuthCredentials {
  const OtpCredentials(this.email);

  final EmailAddress email;
}
