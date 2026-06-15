import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nice/features/training/state/training_view_model.dart';

class TrainingEditorBottomBar extends StatefulWidget {
  const TrainingEditorBottomBar({
    super.key,
    required this.state,
    this.mergeClicked,
    this.openPromptEditorClicked,
  });

  final TrainingState state;
  final VoidCallback? mergeClicked;
  final VoidCallback? openPromptEditorClicked;

  @override
  State<TrainingEditorBottomBar> createState() =>
      _TrainingEditorBottomBarState();
}

class _TrainingEditorBottomBarState extends State<TrainingEditorBottomBar> {
  @override
  Widget build(BuildContext context) {
    if (widget.state.training == null) {
      return const SizedBox.shrink();
    }

    if (widget.state.training!.selector.isNotEmpty) {
      return BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Symbols.graph_1_rounded),
              tooltip: 'Mesclar exercícios',
              onPressed: widget.state.training!.selector.canMerge
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
