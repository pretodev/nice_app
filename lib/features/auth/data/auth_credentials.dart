import 'package:flutter/widgets.dart';
import 'package:nice/features/auth/data/email_address.dart';

sealed class AuthCredentials {
  const AuthCredentials();
}

class EmailLinkCredentials extends AuthCredentials {
  const EmailLinkCredentials(this.email, {this.link});

  final EmailAddress email;
  final String? link;

  EmailLinkCredentials copyWith({
    EmailAddress? email,
    ValueGetter<String?>? link,
  }) {
    return EmailLinkCredentials(
      email ?? this.email,
      link: link?.call() ?? this.link,
    );
  }
}
