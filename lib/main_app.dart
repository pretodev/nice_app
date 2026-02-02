import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/login_view.dart';
import 'package:nice/features/auth/otp_verification_view.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/placeholder_view.dart';
import 'package:nice/features/user/state/commands/load_user_command.dart';
import 'package:nice/features/user/state/user_store.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    ref.read(loadUserCommandProvider.notifier).call();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userStoreProvider, (previous, next) {
      if (next.status == UserStatus.authenticated) {
        Navigator.of(context).pushReplacement(PlaceholderView.route());
        return;
      }

      if (next.status == UserStatus.unauthenticated) {
        final authState = ref.watch(authStoreProvider);
        switch (authState.credentials) {
          case OtpCredentials(:final email):
            Navigator.of(context).pushReplacement(
              OtpVerificationView.route(email: email),
            );
          default:
            Navigator.of(context).pushReplacement(LoginView.route());
        }
      }
    });

    final loadUserState = ref.watch(loadUserCommandProvider);

    return MaterialApp(
      title: 'Nice',
      home: Scaffold(
        body: Center(
          child: loadUserState.maybeWhen(
            error: (error, stackTrace) => Text(error.toString()),
            orElse: () => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
