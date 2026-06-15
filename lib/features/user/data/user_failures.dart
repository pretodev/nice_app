import 'package:nice/core/fp/fp.dart';

class UserNotAuthenticated extends Failure {
  const UserNotAuthenticated() : super('User is not authenticated');
}
