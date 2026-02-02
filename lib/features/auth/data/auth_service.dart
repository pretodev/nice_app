import 'dart:math';

import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/data/pocketbase/pocketbase_exception.dart';
import 'package:odu_core/odu_core.dart';
import 'package:pocketbase/pocketbase.dart';

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

  Future<void> _prepareUser(EmailAddress email) async {
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
    } on ClientException catch (e) {
      final status = e.response['status'];
      final data = e.response['data'];
      if (status == 400 && data['email']['code'] == 'validation_not_unique') {
        return;
      }
      rethrow;
    }
  }

  /// Envia um código OTP para o email fornecido
  /// Cria o usuário apenas se não existir
  /// Retorna o otpId que deve ser armazenado pelo repository
  FutureResult<String> sendOtp(EmailAddress email) async {
    try {
      await _prepareUser(email);
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
}
