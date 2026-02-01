import 'package:pocketbase/pocketbase.dart';

import '../auth_failures.dart';

extension ClientExceptionExtensions on ClientException {
  AuthFailure toAuthFailure() {
    final message = response['message']?.toString().toLowerCase() ?? '';

    // Mapear por status code
    switch (statusCode) {
      case 400:
        if (message.contains('otp')) {
          return const InvalidOtpFailure();
        }
        if (message.contains('email')) {
          return const InvalidEmailFailure();
        }
        return EmailNotSentFailure(response['message']?.toString());

      case 404:
        return const InvalidEmailFailure();

      case 429:
        return const TooManyRequestsFailure();

      case 500 || 502 || 503:
        return UnknownAuthFailure(response['message']?.toString());

      default:
        return UnknownAuthFailure(response['message']?.toString());
    }
  }
}
