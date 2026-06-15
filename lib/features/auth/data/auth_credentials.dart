import 'package:nice/features/auth/data/email_address.dart';

sealed class const AuthCredentials();

class const OtpCredentials({
  required final EmailAddress email,
  required final String otpId,
}) extends AuthCredentials;
