import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/ui/views/awaiting_confirmation_view.dart';

import '../../user/ui/placeholder_view.dart';
import '../data/auth_state.dart';
import '../providers/provider_queries.dart';
import 'views/login_view.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (state) {
        return switch (state) {
          Unauthenticated() => const LoginView(),
          Authenticated() => const PlaceholderView(),
          WaitingForEmailConfirmation(:final email) => AwaitingConfirmationView(
            email: email,
          ),
        };
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
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
