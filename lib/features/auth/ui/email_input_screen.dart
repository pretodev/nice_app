import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:email_validator/email_validator.dart';
import 'package:nice/features/auth/providers/auth_providers.dart';
import 'package:nice/features/auth/data/auth_state.dart';
import 'package:nice/features/auth/ui/otp_verification_screen.dart';

class EmailInputScreen extends ConsumerStatefulWidget {
  const EmailInputScreen({super.key});

  @override
  ConsumerState<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends ConsumerState<EmailInputScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEmailValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    setState(() {
      _isEmailValid = EmailValidator.validate(value);
    });
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    await ref.read(authControllerProvider.notifier).sendOtp(email);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is OtpSent) {
        // Navigate to OTP verification screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(email: next.email),
          ),
        );
      } else if (next is AuthError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or App Name
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  'Acesso Seguro',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                const Text(
                  'Informe seu e-mail para receber o código de acesso',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Email Input
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onChanged: _onEmailChanged,
                  onFieldSubmitted: (_) {
                    if (_isEmailValid) {
                      _onContinue();
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'seu@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe um e-mail';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Continue Button
                ElevatedButton(
                  onPressed: authState is AuthLoading || !_isEmailValid
                      ? null
                      : _onContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: authState is AuthLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Info Text
                const Text(
                  'Ao continuar, você receberá um código de verificação no seu e-mail',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
