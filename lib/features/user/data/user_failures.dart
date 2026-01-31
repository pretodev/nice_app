class UserNotAuthenticated implements Exception {
  const UserNotAuthenticated();

  @override
  String toString() => 'User is not authenticated';
}
