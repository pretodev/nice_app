import 'package:flutter/material.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/ui/traning_exercice_editor_view.dart';

class TrainingEditorView extends StatefulWidget {
  const TrainingEditorView({super.key});

  @override
  State<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends State<TrainingEditorView> {
  final Training _training = Training();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, TraningExerciceEditorView.route);
        },
        tooltip: 'Add training',
        child: Icon(Icons.add),
      ),
    );
  }
}
