import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/data/user_failures.dart';
import 'package:nice/features/user/data/user_status.dart';

class UserRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserRepository(this._auth, this._firestore);

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  DateTime _toDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  Stream<UserStatus> get currentStatus {
    return _auth.authStateChanges().map(
      (user) =>
          user != null ? UserStatus.authenticated : UserStatus.unauthenticated,
    );
  }

  FutureResult<UserEntity> get currentUser async {
    final user = _auth.currentUser;
    if (user == null) {
      return const Err(UserNotAuthenticated());
    }

    try {
      final snapshot = await _users.doc(user.uid).get();
      final data = snapshot.data();

      if (!snapshot.exists || data == null) {
        // Cria registro inicial alinhado ao FirebaseUser.
        final now = DateTime.now();
        final initial = <String, dynamic>{
          'email': user.email ?? '',
          'name': user.displayName,
          'avatar': user.photoURL,
          'created_at': Timestamp.fromDate(now),
          'updated_at': Timestamp.fromDate(now),
          'verified': user.emailVerified,
        };
        await _users.doc(user.uid).set(initial);

        return Ok(
          UserEntity(
            id: user.uid,
            email: user.email ?? '',
            displayName: user.displayName,
            photoURL: user.photoURL,
            createdAt: now,
            updatedAt: now,
            isActive: user.emailVerified,
          ),
        );
      }

      return Ok(
        UserEntity(
          id: user.uid,
          email: (data['email'] as String?) ?? user.email ?? '',
          displayName: data['name'] as String? ?? user.displayName,
          photoURL: data['avatar'] as String? ?? user.photoURL,
          createdAt: _toDateTime(data['created_at']),
          updatedAt: _toDateTime(data['updated_at']),
          isActive: data['verified'] as bool? ?? user.emailVerified,
        ),
      );
    } on FirebaseException {
      rethrow;
    }
  }

  FutureResult<Unit> set(UserEntity user) async {
    final current = _auth.currentUser;
    if (current == null) {
      return const Err(UserNotAuthenticated());
    }

    try {
      await _users.doc(current.uid).set(<String, dynamic>{
        'name': user.displayName,
        'avatar': user.photoURL,
        'updated_at': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));

      if ((current.displayName ?? '') != user.displayName) {
        await current.updateDisplayName(user.displayName);
      }
      if (current.photoURL != user.photoURL) {
        await current.updatePhotoURL(user.photoURL);
      }

      return ok;
    } on FirebaseException {
      rethrow;
    }
  }

  FutureResult<Unit> signOut() async {
    await _auth.signOut();
    return ok;
  }
}
