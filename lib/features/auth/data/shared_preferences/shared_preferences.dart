import 'package:nice/features/auth/data/email_address.dart';
import 'package:odu_core/odu_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _emailCredentialsKey = 'auth.credentials.email';
const _otpIdKey = 'auth.credentials.otp_id';

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

  /// Armazena o OTP ID
  FutureResult<Unit> setOtpId(String otpId) async {
    await setString(_otpIdKey, otpId);
    return ok;
  }

  /// Recupera o OTP ID armazenado
  FutureOption<String> getOtpId() async {
    final otpId = getString(_otpIdKey);
    if (otpId == null) {
      return const None();
    }
    return Some(otpId);
  }

  /// Remove o OTP ID
  FutureResult<Unit> deleteOtpId() async {
    await remove(_otpIdKey);
    return ok;
  }
}
