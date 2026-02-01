import 'package:flutter/material.dart';

class CancelOtpVerificationDialog extends StatelessWidget {
  const CancelOtpVerificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancel Verification?'),
      content: const Text(
        'Are you sure you want to go back? You\'ll need to enter your email again to receive a new code.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Keep Verifying'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Go Back',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
