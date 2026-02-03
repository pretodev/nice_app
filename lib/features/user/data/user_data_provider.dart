import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/shared/data/shared_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  final pb = ref.watch(pocketbaseClientProvider);
  return UserRepository(pb);
}
