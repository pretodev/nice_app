import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/training.dart';

class TrainingEditorBottomBar extends StatefulWidget {
  const TrainingEditorBottomBar({
    super.key,
    required this.training,
    required this.mergeClicked,
  });

  final AsyncValue<Training> training;
  final VoidCallback? mergeClicked;

  @override
  State<TrainingEditorBottomBar> createState() =>
      _TrainingEditorBottomBarState();
}

class _TrainingEditorBottomBarState extends State<TrainingEditorBottomBar> {
  @override
  Widget build(BuildContext context) {
    if (!widget.training.hasValue) {
      return const SizedBox.shrink();
    }

    if (widget.training.requireValue.selector.isNotEmpty) {
      return BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Symbols.graph_1_rounded),
              tooltip: 'Mesclar exercícios',
              onPressed: widget.mergeClicked,
            ),
          ],
        ),
      );
    }

    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Symbols.more_vert_rounded),
            tooltip: 'Opções',
            onPressed: widget.mergeClicked,
          ),
        ],
      ),
    );
  }
}
