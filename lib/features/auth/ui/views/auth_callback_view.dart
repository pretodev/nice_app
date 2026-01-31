import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/commands/sign_in_with_email_link_command.dart';

class AuthCallbackView extends ConsumerStatefulWidget {
  const AuthCallbackView({
    super.key,
    required this.link,
  });

  final String link;

  @override
  ConsumerState<AuthCallbackView> createState() => _AuthCallbackViewState();
}

class _AuthCallbackViewState extends ConsumerState<AuthCallbackView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signInWithEmailLinkProvider.notifier).call(widget.link);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInWithEmailLinkProvider, (prev, next) {
      next.when(
        data: (_) {
          context.go('/');
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
          context.go('/');
        },
        loading: () {},
      );
    });

    final state = ref.watch(signInWithEmailLinkProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Signing you in...'),
            ] else if (state.hasError) ...[
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Authentication failed'),
            ] else ...[
              const Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text('Authentication successful'),
            ],
          ],
        ),
      ),
    );
  }
}
