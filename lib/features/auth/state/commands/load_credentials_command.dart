import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

class LoadCredentials extends Command {
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  LoadCredentials({
    required this._authRepository,
    required this._authStore,
  });

  void call() async {
    loading();
    final result = await _authRepository.getOtpCredentials();
    if (result case Some(:final value)) {
      _authStore.otpRequest(value);
    }
    done();
  }
}
