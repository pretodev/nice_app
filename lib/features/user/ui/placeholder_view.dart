import 'package:flutter/material.dart';
import 'package:nice/features/user/state/commands/sign_out_command.dart';
import 'package:nice/features/user/state/user_state.dart';
import 'package:nice/shared/state/scope.dart';

class PlaceholderView extends StatelessWidget {
  static Route<void> route() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const PlaceholderView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  const PlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    context.listen<SignOut>((action) {
      if (action.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              action.error.toString().replaceFirst('Exception: ', ''),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final userState = context.watch<UserStore>().state;
    final signOut = context.watch<SignOut>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nice App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut.call,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome, ${userState.user?.displayName}',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${userState.user?.email}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'User ID: ${userState.user?.id}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Text(
                'This is a placeholder screen. The main app content will be added here.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
