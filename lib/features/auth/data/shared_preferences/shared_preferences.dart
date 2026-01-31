import 'package:nice/features/auth/data/email_address.dart';
import 'package:odu_core/odu_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _emailCredentialsKey = 'auth.credentials.email';

extension SharedPreferencesMapper on SharedPreferences {
  FutureResult<Unit> setEmailAuthCredential(EmailAddress email) async {
    await setString(_emailCredentialsKey, email.value);
    return ok;
  }

  FutureOption<EmailAddress> getEmailAuthCredential() async {
    final data = getString(_emailCredentialsKey);
    if (data == null) {
      return const None();
    }
    return Some(EmailAddress(data));
  }

  FutureResult<Unit> deleteEmailAuthCredential() async {
    await remove(_emailCredentialsKey);
    return ok;
  }
}
