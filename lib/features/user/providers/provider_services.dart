import 'package:nice/features/auth/providers/provider_services.dart';
import 'package:nice/features/user/data/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_services.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  final pb = ref.watch(pocketbaseClientProvider);
  return UserRepository(pb);
}
