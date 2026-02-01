import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user/ui/placeholder_view.dart';
import '../data/auth_state.dart';
import '../providers/provider_queries.dart';
import 'views/login_view.dart';
import 'views/otp_verification_view.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      if (!next.hasValue) {
        return;
      }
      switch (next.requireValue) {
        case Unauthenticated():
          Navigator.pushReplacement(context, LoginView.route());
        case Authenticated():
          Navigator.pushReplacement(context, PlaceholderView.route());
        case WaitingForOtpVerification(:final email):
          Navigator.pushReplacement(
            context,
            OtpVerificationView.route(email: email),
          );
      }
    });

    return ref
        .watch(authStateProvider)
        .maybeWhen(
          orElse: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                ],
              ),
            ),
          ),
        );
  }
}
