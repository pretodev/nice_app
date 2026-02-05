import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    this.controller,
    this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email address',
        errorText: errorText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }
}
