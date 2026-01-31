import 'package:nice/features/user/data/user_entity.dart';
import 'package:nice/features/user/providers/provider_services.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_queries.g.dart';

@riverpod
Future<UserEntity> currentUser(Ref ref) async {
  final user = await ref.watch(userRepositoryProvider).currentUser;
  switch (user) {
    case Ok(:final value):
      return value;
    default:
      throw UnimplementedError();
  }
}
