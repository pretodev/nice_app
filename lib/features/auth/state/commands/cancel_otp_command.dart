import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/state/command.dart';

class CancelOtp extends Command {
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  CancelOtp({
    required AuthRepository authRepository,
    required AuthStore authStore,
  }) : _authRepository = authRepository,
       _authStore = authStore;

  void call() async {
    loading();
    final result = await _authRepository.deleteCredentials();
    if (result.isOk) {
      _authStore.clearCredentials();
    }
    done();
  }
}
