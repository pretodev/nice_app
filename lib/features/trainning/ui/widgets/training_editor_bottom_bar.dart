import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/training.dart';

class TrainingEditorBottomBar extends StatefulWidget {
  const TrainingEditorBottomBar({
    super.key,
    required this.training,
    this.mergeClicked,
    this.openPromptEditorClicked,
  });

  final AsyncValue<DailyTraining> training;
  final VoidCallback? mergeClicked;
  final VoidCallback? openPromptEditorClicked;

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
              icon: const Icon(Symbols.graph_1_rounded),
              tooltip: 'Mesclar exercícios',
              onPressed: widget.training.requireValue.selector.canMerge
                  ? widget.mergeClicked
                  : null,
            ),
          ],
        ),
      );
    }

    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset('assets/svg/sparkles.svg'),
            tooltip: 'Opções',
            onPressed: widget.openPromptEditorClicked,
          ),
        ],
      ),
    );
  }
}
