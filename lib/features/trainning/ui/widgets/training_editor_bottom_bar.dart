import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum TrainingEditorState {
  none,
  merging,
  selecting,
}

class TrainingEditorBottomBar extends StatelessWidget {
  const TrainingEditorBottomBar({
    super.key,
    required this.state,
    this.startMerge,
    this.editExercise,
    this.removeExercise,
    this.finishMerge,
  });

  final TrainingEditorState state;
  final VoidCallback? startMerge;
  final VoidCallback? editExercise;
  final VoidCallback? removeExercise;
  final VoidCallback? finishMerge;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      TrainingEditorState.none => SizedBox.shrink(),
      TrainingEditorState.merging => BottomAppBar(
        child: Row(
          children: [
            TextButton(
              onPressed: finishMerge,
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
      TrainingEditorState.selecting => BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Symbols.edit_rounded),
              tooltip: 'Editar exercício',
              onPressed: editExercise,
            ),
            IconButton(
              icon: Icon(Symbols.delete_rounded),
              tooltip: 'Deletar exercício',
              onPressed: removeExercise,
            ),
            IconButton(
              icon: Icon(Symbols.graph_1_rounded),
              tooltip: 'Mesclar exercícios',
              onPressed: startMerge,
            ),
          ],
        ),
      ),
    };
  }
}
