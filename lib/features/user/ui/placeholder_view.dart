import 'package:flutter/material.dart';
import 'package:nice/features/user/state/user_view_model.dart';
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
    final userVm = context.watch<UserViewModel>();
    final userState = userVm.state;
    final signOut = context.watchCommand(userVm.signOut);

    context.listenCommand(userVm.signOut, (command) {
      if (!command.isError) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(command.failure?.message ?? 'Erro inesperado'),
          backgroundColor: Colors.red,
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nice App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut.isWaiting ? null : userVm.signOut.call,
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
