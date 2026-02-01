import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/shared_preferences/shared_preferences.dart';
import 'package:odu_core/odu_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  FutureResult<Unit> store(AuthCredentials credentials) async {
    if (credentials is OtpCredentials) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setOtpCredentials(credentials);
      return ok;
    }
    return const Err(UnknownAuthFailure('Credentials are not OTP credentials'));
  }

  FutureOption<OtpCredentials> getOtpCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getOtpCredentials();
  }

  FutureResult<Unit> deleteCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.deleteOptCredentials();
    return ok;
  }
}
