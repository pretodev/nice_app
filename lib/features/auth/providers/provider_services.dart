import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/shared/environment.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_service.dart';

part 'provider_services.g.dart';

/// Provider para a instância singleton do PocketBase
@riverpod
PocketBase pocketbaseClient(Ref ref) {
  return PocketBase(Environment.pocketbaseUrl);
}

@riverpod
AuthService authService(Ref ref) {
  final pb = ref.watch(pocketbaseClientProvider);
  return AuthService(pb);
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}
