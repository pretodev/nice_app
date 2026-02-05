import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/data/user_failures.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:odu_core/odu_core.dart';
import 'package:pocketbase/pocketbase.dart';

class UserRepository {
  final PocketBase _pb;

  UserRepository(this._pb);

  DateTime _toDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  Stream<UserStatus> get currentStatus async* {
    if (_pb.authStore.isValid) {
      try {
        await _pb.collection('users').authRefresh();
      } catch (_) {
        _pb.authStore.clear();
      }
    }
    final initialRecord = _pb.authStore.record;
    final initialState = initialRecord != null
        ? UserStatus.authenticated
        : UserStatus.unauthenticated;
    yield initialState;

    await for (final authStore in _pb.authStore.onChange) {
      final state = authStore.record != null
          ? UserStatus.authenticated
          : UserStatus.unauthenticated;
      yield state;
    }
  }

  FutureResult<UserEntity> get currentUser async {
    final record = _pb.authStore.record;
    if (record == null) {
      return const Err(UserNotAuthenticated());
    }

    try {
      final response = await _pb.collection('users').getOne(record.id);

      return Ok(
        UserEntity(
          id: response.id,
          email: response.data['email'] as String,
          displayName: response.data['name'] as String?,
          photoURL: response.data['avatar'] as String?,
          createdAt: _toDateTime(response.get<String>('created')),
          updatedAt: _toDateTime(response.get<String>('updated')),
          isActive: response.data['verified'] as bool? ?? false,
        ),
      );
    } on ClientException catch (e) {
      // If user not found in collection, return minimal entity from authStore
      if (e.statusCode == 404) {
        return Ok(
          UserEntity(
            id: record.id,
            email: record.data['email'] as String? ?? '',
            createdAt: _toDateTime(record.get<String>('created')),
            updatedAt: _toDateTime(record.get<String>('updated')),
          ),
        );
      }
      rethrow;
    }
  }

  FutureResult<Unit> set(UserEntity user) async {
    final record = _pb.authStore.record;
    if (record == null) {
      return const Err(UserNotAuthenticated());
    }

    try {
      await _pb
          .collection('users')
          .update(
            record.id,
            body: {
              'name': user.displayName,
              'avatar': user.photoURL,
            },
          );

      return ok;
    } on ClientException {
      rethrow;
    }
  }

  FutureResult<Unit> signOut() async {
    _pb.authStore.clear();
    return ok;
  }
}
