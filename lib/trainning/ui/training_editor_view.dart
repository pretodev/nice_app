import 'package:flutter/material.dart';
import 'package:nice/trainning/data/training.dart';

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
        onPressed: () {},
        tooltip: 'Add training',
        child: Icon(Icons.add),
      ),
    );
  }
}
