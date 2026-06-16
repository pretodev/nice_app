import 'package:nice/core/fp/fp.dart';

class UserNotAuthenticated extends Failure {
  const UserNotAuthenticated() : super('User is not authenticated');
}

class AnonymousSignInFailure extends Failure {
  const AnonymousSignInFailure({super.debugDetails, super.stackTrace})
    : super('Não foi possível iniciar uma sessão anônima');
}
