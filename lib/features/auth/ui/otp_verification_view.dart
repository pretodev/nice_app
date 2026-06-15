import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nice/core/injector/scope.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/auth_view_model.dart';
import 'package:nice/features/auth/ui/cancel_otp_verification_view.dart';
import 'package:nice/features/auth/ui/widgets/primary_button.dart';

/// Tela mostrada após o app disparar um sign-in link por email.
class OtpVerificationView extends StatefulWidget {
  static Route<void> route({required EmailAddress email}) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          OtpVerificationView(
            email: email,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  const OtpVerificationView({super.key, required this.email});

  final EmailAddress email;

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  Timer? _cooldownTimer;
  int _remainingSeconds = 60;
  final _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _linkController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _remainingSeconds = 60);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          timer.cancel();
        }
      });
    });
  }

  void _handleCancelOtp(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const CancelOtpVerificationView(),
    );

    if (!mounted) return;

    if (confirmed == true) {
      _cooldownTimer?.cancel();
      _remainingSeconds = 0;
      if (!mounted) return;
      this.context.read<AuthViewModel>().cancelOtp();
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthViewModel>();

    context.listenCommand(authVm.sendOtp, (command) {
      if (command.isError) {
        _showError(context, command.failure?.message ?? 'Erro inesperado');
        return;
      }
      if (command.isDone) {
        _startCooldown();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-in link sent. Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    context.listenCommand(authVm.verifyOtp, (command) {
      if (command.isError) {
        _showError(context, command.failure?.message ?? 'Erro inesperado');
      }
    });

    context.listenCommand(authVm.cancelOtp, (command) {
      if (command.isError) {
        _showError(context, command.failure?.message ?? 'Erro inesperado');
      }
    });

    final sendOtp = context.watchCommand(authVm.sendOtp);
    final verifyOtp = context.watchCommand(authVm.verifyOtp);
    final cancelOtp = context.watchCommand(authVm.cancelOtp);

    final isLoading =
        sendOtp.isWaiting || verifyOtp.isWaiting || cancelOtp.isWaiting;

    final canResend = _remainingSeconds <= 0 && !isLoading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleCancelOtp(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Check your email'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleCancelOtp(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 32),
                Text(
                  'We sent you a sign-in link',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Open the email we sent to:',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email.value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap the link inside the email to finish signing in.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _linkController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Paste sign-in link (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  onPressed: !isLoading
                      ? () {
                          final link = _linkController.text.trim();
                          if (link.isEmpty) return;
                          authVm.verifyOtp(link);
                        }
                      : null,
                  text: 'Sign in with link',
                  isLoading: verifyOtp.isWaiting,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: canResend
                      ? () => authVm.sendOtp(widget.email)
                      : null,
                  child: Text(
                    _remainingSeconds > 0
                        ? 'Resend link in $_remainingSeconds seconds'
                        : 'Resend link',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
