import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/shared/data/shared_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_data_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  final pb = ref.watch(pocketbaseClientProvider);
  return AuthService(pb);
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}
