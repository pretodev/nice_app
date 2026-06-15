import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _emailCredentialsKey = 'auth.credentials.email_link_email';

extension SharedPreferencesMapper on SharedPreferences {
  FutureResult<Unit> setEmailLinkCredentials(
    EmailLinkCredentials credentials,
  ) async {
    await setString(_emailCredentialsKey, credentials.email.value);
    return ok;
  }

  FutureOption<EmailLinkCredentials> getEmailLinkCredentials() async {
    final email = getString(_emailCredentialsKey);
    if (email == null) {
      return const None();
    }
    return Some(
      EmailLinkCredentials(email: EmailAddress(email)),
    );
  }

  FutureResult<Unit> deleteEmailLinkCredentials() async {
    await remove(_emailCredentialsKey);
    return ok;
  }
}
