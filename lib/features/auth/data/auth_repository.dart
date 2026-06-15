import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  FutureResult<Unit> store(AuthCredentials credentials) async {
    if (credentials is EmailLinkCredentials) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setEmailLinkCredentials(credentials);
      return ok;
    }
    return const Err(
      UnknownAuthFailure('Credentials are not email link credentials'),
    );
  }

  FutureOption<EmailLinkCredentials> getEmailLinkCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getEmailLinkCredentials();
  }

  FutureResult<Unit> deleteCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.deleteEmailLinkCredentials();
    return ok;
  }
}
