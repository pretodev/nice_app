import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:odu_core/odu_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _emailCredentialsKey = 'auth.credentials.otp_email';
const _otpIdKey = 'auth.credentials.otp_id';

extension SharedPreferencesMapper on SharedPreferences {
  FutureResult<Unit> setOtpCredentials(OtpCredentials credentials) async {
    await setString(_otpIdKey, credentials.otpId);
    await setString(_emailCredentialsKey, credentials.email.value);
    return ok;
  }

  FutureOption<OtpCredentials> getOtpCredentials() async {
    final email = getString(_emailCredentialsKey);
    if (email == null) {
      return const None();
    }
    final otpId = getString(_otpIdKey);
    if (otpId == null) {
      return const None();
    }
    return Some(
      OtpCredentials(
        email: EmailAddress(email),
        otpId: otpId,
      ),
    );
  }

  FutureResult<Unit> deleteOptCredentials() async {
    await remove(_emailCredentialsKey);
    await remove(_otpIdKey);
    return ok;
  }
}
