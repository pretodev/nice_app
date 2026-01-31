import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/data/email_address.dart';

import '../../providers/commands/send_sign_in_link_command.dart';
import '../widgets/primary_button.dart';

class AwaitingConfirmationView extends ConsumerStatefulWidget {
  const AwaitingConfirmationView({
    super.key,
    required this.email,
  });

  final EmailAddress email;

  @override
  ConsumerState<AwaitingConfirmationView> createState() =>
      _AwaitingConfirmationViewState();
}

class _AwaitingConfirmationViewState
    extends ConsumerState<AwaitingConfirmationView> {
  Timer? _cooldownTimer;
  int _remainingSeconds = 0;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
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

  @override
  Widget build(BuildContext context) {
    ref.listen(sendSignInLinkProvider, (prev, next) {
      next.when(
        data: (_) {
          _startCooldown();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email sent successfully'),
              backgroundColor: Colors.green,
            ),
          );
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
    final canResend = _remainingSeconds <= 0 && !isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Your Email'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.mail_outline,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                'Email Sent!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We sent a sign-in link to:',
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
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      'Click the link in your email to sign in',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The link will expire in 10 minutes',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                onPressed: canResend
                    ? () {
                        ref
                            .read(sendSignInLinkProvider.notifier)
                            .call(widget.email);
                      }
                    : null,
                text: _remainingSeconds > 0
                    ? 'Resend in $_remainingSeconds seconds'
                    : 'Resend Email',
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
