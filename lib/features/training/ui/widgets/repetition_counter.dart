import 'package:flutter/material.dart';

class RepetitionCounter extends StatefulWidget {
  const RepetitionCounter({
    super.key,
    this.value = 12,
    this.onChanged,
  });

  final int value;
  final ValueChanged<int>? onChanged;

  @override
  State<RepetitionCounter> createState() => _RepetitionCounterState();
}

class _RepetitionCounterState extends State<RepetitionCounter> {
  int _value = 12;

  void _increment() {
    setState(() {
      _value++;
      widget.onChanged?.call(_value);
    });
  }

  void _decrement() {
    setState(() {
      if (_value > 1) {
        _value--;
        widget.onChanged?.call(_value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(RepetitionCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$_value',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _increment,
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _decrement,
          ),
        ],
      ),
    );
  }
}
