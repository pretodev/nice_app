import 'package:flutter/material.dart';

class CancelOtpVerificationView extends StatelessWidget {
  const CancelOtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancel sign-in?'),
      content: const Text(
        'Are you sure you want to go back? You\'ll need to enter your email again to receive a new sign-in link.',
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
