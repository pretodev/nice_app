import 'package:nice/features/auth/data/email_address.dart';

sealed class const AuthCredentials();

/// Credenciais geradas quando um link de login do Firebase Email Link foi
/// disparado e o app aguarda o usuário concluir o fluxo (clicando no link
/// recebido por email).
class const EmailLinkCredentials({
  required final EmailAddress email,
}) extends AuthCredentials;
