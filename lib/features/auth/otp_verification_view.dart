import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/cancel_otp_verification_view.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/commands/cancel_otp_command.dart';
import 'package:nice/features/auth/state/commands/send_otp_command.dart';
import 'package:nice/features/auth/state/commands/verify_otp_command.dart';
import 'package:nice/features/auth/widgets/otp_input_field.dart';
import 'package:nice/features/auth/widgets/primary_button.dart';

class OtpVerificationView extends ConsumerStatefulWidget {
  static MaterialPageRoute<void> route({required EmailAddress email}) {
    return MaterialPageRoute<void>(
      builder: (context) => OtpVerificationView(
        email: email,
      ),
    );
  }

  const OtpVerificationView({super.key, required this.email});

  final EmailAddress email;

  @override
  ConsumerState<OtpVerificationView> createState() =>
      _OtpVerificationViewState();
}

class _OtpVerificationViewState extends ConsumerState<OtpVerificationView> {
  Timer? _cooldownTimer;
  int _remainingSeconds = 0;
  String? _errorText;
  String _otpCode = '';

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

  void _handleCancelOtp(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const CancelOtpVerificationView(),
    );

    if (!mounted) return;

    if (confirmed == true) {
      _otpCode = '';
      _errorText = null;
      _cooldownTimer?.cancel();
      _remainingSeconds = 0;
      ref.read(cancelOtpProvider.notifier).call();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sendOtpProvider, (prev, next) {
      next.when(
        data: (_) {
          _startCooldown();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP code sent successfully'),
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

    ref.listen(verifyOtpProvider, (prev, next) {
      next.when(
        data: (_) {},
        error: (error, _) {
          setState(() {
            _errorText = error.toString().replaceFirst('Exception: ', '');
          });
        },
        loading: () {
          setState(() => _errorText = null);
        },
      );
    });

    ref.listen(cancelOtpProvider, (prev, next) {
      next.when(
        data: (_) {},
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

    final sendOtpState = ref.watch(sendOtpProvider);
    final verifyOtpState = ref.watch(verifyOtpProvider);
    final cancelOtpState = ref.watch(cancelOtpProvider);
    final isLoading =
        sendOtpState.isLoading ||
        verifyOtpState.isLoading ||
        cancelOtpState.isLoading;
    final canResend = _remainingSeconds <= 0 && !isLoading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleCancelOtp(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify Your Email'),
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
                const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                const SizedBox(height: 32),
                Text(
                  'Enter Verification Code',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'We sent an 8-digit code to:',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email.value,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OtpInputField(
                  onCompleted: (code) {
                    setState(() => _otpCode = code);
                  },
                  errorText: _errorText,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  onPressed: _otpCode.length == 8 && !isLoading
                      ? () {
                          ref.read(verifyOtpProvider.notifier).call(_otpCode);
                        }
                      : null,
                  text: 'Verify',
                  isLoading: verifyOtpState.isLoading,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: canResend
                      ? () {
                          ref.read(sendOtpProvider.notifier).call(widget.email);
                        }
                      : null,
                  child: Text(
                    _remainingSeconds > 0
                        ? 'Resend code in $_remainingSeconds seconds'
                        : 'Resend code',
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
