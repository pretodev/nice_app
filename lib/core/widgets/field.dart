import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  const Field({
    super.key,
    required this.label,
    required this.child,
    this.icon,
  });

  final Icon? icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        spacing: 8.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            spacing: icon != null ? 8.0 : 0.0,
            children: [
              icon ?? SizedBox.shrink(),
              Expanded(child: child),
            ],
          ),
        ],
      ),
    );
  }
}
