import 'package:odu_core/odu_core.dart';

class UserEntity extends GuidEntity {
  UserEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.isActive,
    required this.email,
    String? displayName,
    this.photoURL,
  }) : _displayName = displayName ?? '';

  final String email;
  final String? photoURL;

  String _displayName;

  set displayName(String value) {
    if (value.isEmpty) {
      throw ArgumentError('displayName must not be empty');
    }
    _displayName = value;
  }

  String get displayName => _displayName;
}
