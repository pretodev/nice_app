import 'dart:math';

import 'package:nice/features/auth/data/pocketbase/pocketbase_exception.dart';
import 'package:odu_core/odu_core.dart';
import 'package:pocketbase/pocketbase.dart';

import 'auth_failures.dart';
import 'auth_state.dart' as app;
import 'email_address.dart';

// Gerar senha aleatória de 12 caracteres com capitalização, números e símbolos
String _generateRandomPassword() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-={}[]|\\:;"<>,.?/~`';
  final random = Random();
  return List.generate(
    12,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
}

class AuthService {
  final PocketBase _pb;

  AuthService(this._pb);

  /// Envia um código OTP para o email fornecido
  /// Retorna o otpId que deve ser armazenado pelo repository
  FutureResult<String> sendOtp(EmailAddress email) async {
    try {
      final password = _generateRandomPassword();
      await _pb
          .collection('users')
          .create(
            body: {
              'email': email.value,
              'password': password,
              'passwordConfirm': password,
            },
          );
      final result = await _pb.collection('users').requestOTP(email.value);
      return Ok(result.otpId);
    } on ClientException catch (e, s) {
      return Err(e.toAuthFailure(), s);
    }
  }

  /// Verifica o código OTP usando o otpId fornecido
  FutureResult<Unit> verifyOtp({
    required String otpId,
    required String otp,
  }) async {
    try {
      await _pb.collection('users').authWithOTP(otpId, otp);
      return ok;
    } on ClientException catch (e, s) {
      return Err(e.toAuthFailure(), s);
    } catch (e, s) {
      return Err(UnknownAuthFailure(e.toString()), s);
    }
  }

  /// Stream que monitora mudanças no estado de autenticação
  /// Emite o estado inicial imediatamente, depois monitora mudanças
  Stream<app.AuthState> get state async* {
    final initialRecord = _pb.authStore.record;
    final initialState = initialRecord != null
        ? const app.Authenticated()
        : const app.Unauthenticated();
    yield initialState;

    await for (final authStore in _pb.authStore.onChange) {
      final state = authStore.record != null
          ? const app.Authenticated()
          : const app.Unauthenticated();
      yield state;
    }
  }

  /// Realiza logout e limpa o armazenamento de autenticação
  FutureResult<Unit> signOut() async {
    try {
      _pb.authStore.clear();
      return ok;
    } catch (e, s) {
      return Err(UnknownAuthFailure(e.toString()), s);
    }
  }
}
