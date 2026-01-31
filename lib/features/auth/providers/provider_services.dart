import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_service.dart';

part 'provider_services.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}
