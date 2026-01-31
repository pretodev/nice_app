class InvalidEmailException implements Exception {
  const InvalidEmailException();
}

class EmailAddress {
  const EmailAddress._(this.value);

  factory EmailAddress(String email) {
    if (!_isValid(email)) {
      throw const InvalidEmailException();
    }
    return EmailAddress._(email);
  }

  final String value;

  static final _regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static bool _isValid(String email) {
    return _regex.hasMatch(email);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAddress &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
