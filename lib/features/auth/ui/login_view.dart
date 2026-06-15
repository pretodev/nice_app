import 'package:flutter/material.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/auth_view_model.dart';
import 'package:nice/features/auth/ui/widgets/email_field.dart';
import 'package:nice/features/auth/ui/widgets/primary_button.dart';
import 'package:nice/shared/state/scope.dart';

class LoginView extends StatefulWidget {
  static Route<void> route() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthViewModel>();
    final sendOtp = context.watchCommand(authVm.sendOtp);

    context.listenCommand(authVm.sendOtp, (command) {
      if (!command.isError) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(command.failure?.message ?? 'Erro inesperado'),
          backgroundColor: Colors.red,
        ),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.fitness_center, size: 80, color: Colors.blue),
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
                enabled: !sendOtp.isWaiting,
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
                  authVm.sendOtp(EmailAddress(emailValue));
                },
                text: 'Entrar',
                isLoading: sendOtp.isWaiting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
