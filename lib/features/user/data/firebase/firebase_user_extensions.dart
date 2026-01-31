import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/features/user/data/user_entity.dart';

extension FirebaseUserExtensions on User {
  UserEntity toEntity() {
    return UserEntity(
      id: uid,
      email: email ?? '',
      displayName: displayName,
      photoURL: photoURL,
      createdAt: metadata.creationTime ?? DateTime.now(),
      updatedAt: metadata.lastSignInTime ?? DateTime.now(),
    );
  }
}
