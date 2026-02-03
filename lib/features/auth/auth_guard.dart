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

class AuthGuard extends ConsumerStatefulWidget {
  const AuthGuard({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends ConsumerState<AuthGuard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(loadUserCommandProvider.notifier).call());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStoreProvider);
    ref.listen(userStoreProvider, (previous, next) {
      if (next.status == UserStatus.authenticated) {
        Navigator.of(context).pushReplacement(PlaceholderView.route());
        return;
      }

      if (next.status == UserStatus.unauthenticated) {
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

    if (loadUserState case AsyncError(:final error)) {
      return Scaffold(
        body: Center(
          child: Text(error.toString()),
        ),
      );
    }

    if (loadUserState case AsyncLoading()) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return widget.child;
  }
}
