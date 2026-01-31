import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/features/user/data/firebase/firebase_user_extensions.dart';
import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/data/user_failures.dart';
import 'package:odu_core/odu_core.dart';

class UserRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  FutureResult<UserEntity> get currentUser async {
    final user = _firebaseAuth.currentUser?.toEntity();
    if (user == null) {
      return const Err(UserNotAuthenticated());
    }
    return Ok(user);
  }

  FutureResult<Unit> set(UserEntity user) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return const Err(UserNotAuthenticated());
    }
    await Future.wait([
      currentUser.updateDisplayName(user.displayName),
      currentUser.updatePhotoURL(user.photoURL),
    ]);
    currentUser.reload();
    return ok;
  }
}
