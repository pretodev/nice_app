import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nice/features/auth/data/email_address.dart';

import '../../providers/commands/send_sign_in_link_command.dart';
import '../widgets/email_field.dart';
import '../widgets/primary_button.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sendSignInLinkProvider, (prev, next) {
      next.when(
        data: (_) {
          context.go('/awaiting-confirmation', extra: _emailController.text);
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {},
      );
    });

    final commandState = ref.watch(sendSignInLinkProvider);
    final isLoading = commandState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                'Bem-vindo ao Nice App',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Entrar com seu email para continuar',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              EmailField(
                controller: _emailController,
                errorText: _errorText,
                enabled: !isLoading,
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() => _errorText = null);
                  }
                },
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: () {
                  final emailValue = _emailController.text.trim();
                  if (emailValue.isEmpty) {
                    setState(() => _errorText = 'Email é obrigatório');
                    return;
                  }
                  ref
                      .read(sendSignInLinkProvider.notifier)
                      .call(EmailAddress(emailValue));
                },
                text: 'Entrar',
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
