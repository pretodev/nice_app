import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/ui/traning_exercice_editor_view.dart';

class TrainingEditorView extends ConsumerStatefulWidget {
  const TrainingEditorView({super.key});

  @override
  ConsumerState<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends ConsumerState<TrainingEditorView> {
  void _addExercise() {
    Navigator.push(
      context,
      TraningExerciceEditorView.route(training: Training()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        tooltip: 'Add training',
        child: Icon(Icons.add),
      ),
    );
  }
}
