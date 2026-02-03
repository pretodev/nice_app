import 'package:flutter/material.dart';

class SeriesCounter extends StatelessWidget {
  const SeriesCounter({
    super.key,
    this.value = 3,
    this.onIncrementClicked,
    this.onDecrementClicked,
  });

  final int value;
  final VoidCallback? onIncrementClicked;
  final VoidCallback? onDecrementClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('$value', style: Theme.of(context).textTheme.bodyLarge),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            onIncrementClicked?.call();
          },
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            onDecrementClicked?.call();
          },
        ),
      ],
    );
  }
}
