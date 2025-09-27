import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/training_provider.dart';
import 'package:nice/features/trainning/ui/traning_exercise_editor_view.dart';

class TrainingEditorView extends ConsumerStatefulWidget {
  const TrainingEditorView({super.key});

  @override
  ConsumerState<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends ConsumerState<TrainingEditorView> {
  Training _training = Training(id: 'teste');

  late final repo = ref.read(trainingRepositoryProvider);

  void _addExercise() {
    Navigator.push(
      context,
      TraningExerciseEditorView.route(training: _training),
    );
  }

  StreamSubscription<Training>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = repo.fromId('teste').listen((training) {
      setState(() {
        _training = training;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Editor'),
      ),
      body: Text(_training.toString()),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        tooltip: 'Add training',
        child: Icon(Icons.add),
      ),
    );
  }
}
