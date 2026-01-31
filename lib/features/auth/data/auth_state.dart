import 'package:nice/features/auth/data/email_address.dart';

sealed class AuthState {
  const AuthState();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Authenticated extends AuthState {
  const Authenticated();
}

class WaitingForEmailConfirmation extends AuthState {
  final EmailAddress email;

  const WaitingForEmailConfirmation(this.email);
}
