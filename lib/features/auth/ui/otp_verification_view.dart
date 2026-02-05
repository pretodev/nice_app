import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/commands/cancel_otp_command.dart';
import 'package:nice/features/auth/state/commands/send_otp_command.dart';
import 'package:nice/features/auth/state/commands/verify_otp_command.dart';
import 'package:nice/features/auth/ui/cancel_otp_verification_view.dart';
import 'package:nice/features/auth/ui/widgets/otp_input_field.dart';
import 'package:nice/features/auth/ui/widgets/primary_button.dart';
import 'package:nice/shared/state/scope.dart';

class OtpVerificationView extends ConsumerStatefulWidget {
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
      context.read<CancelOtp>().call();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.listen<SendOtp>((state) {
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.error.toString().replaceFirst('Exception: ', ''),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _startCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP code sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });

    context.listen<VerifyOtp>((state) {
      if (state.isLoading) {
        setState(() => _errorText = null);
        return;
      }

      if (state.hasError) {
        setState(() {
          _errorText = state.error.toString().replaceFirst('Exception: ', '');
        });
        return;
      }
    });

    context.listen<CancelOtp>((state) {
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.error.toString().replaceFirst('Exception: ', ''),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final sendOtp = context.watch<SendOtp>();
    final verifyOtp = context.watch<VerifyOtp>();
    final cancelOtp = context.watch<CancelOtp>();

    final isLoading =
        sendOtp.isLoading || verifyOtp.isLoading || cancelOtp.isLoading;

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
                  onPressed: _otpCode.length == 6 && !isLoading
                      ? () => verifyOtp(_otpCode)
                      : null,
                  text: 'Verify',
                  isLoading: verifyOtp.isLoading,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: canResend ? () => sendOtp(widget.email) : null,
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
