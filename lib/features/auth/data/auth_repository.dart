import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/shared_preferences/shared_preferences.dart';
import 'package:odu_core/odu_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  FutureResult<Unit> store(AuthCredentials credentials) async {
    if (credentials is OtpCredentials) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setEmailAuthCredential(credentials.email);
      return ok;
    }
    return const Err(UnknownAuthFailure('Credentials are not OTP credentials'));
  }

  /// Armazena o OTP ID em SharedPreferences
  FutureResult<Unit> storeOtpId(String otpId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setOtpId(otpId);
      return ok;
    } catch (e) {
      return Err(UnknownAuthFailure(e.toString()));
    }
  }

  /// Recupera o OTP ID armazenado
  FutureOption<String> getOtpId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getOtpId();
    } catch (e) {
      return const None();
    }
  }

  FutureOption<OtpCredentials> getOtpCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getEmailAuthCredential().map((email) {
      return OtpCredentials(email);
    });
  }

  FutureResult<Unit> deleteCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return ok;
  }
}
