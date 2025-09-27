import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';
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

  Widget _buildExerciseCard(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 2.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            exercise.execution.formatted,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (exercise.load != null)
            Text(
              'Load: ${exercise.load}kg',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSetHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildSetWidgets(ExerciseSet set, int setIndex) {
    final widgets = <Widget>[];

    switch (set) {
      case StraightSet straightSet:
        widgets.add(_buildExerciseCard(straightSet.data));

      case BiSet biSet:
        widgets.add(_buildSetHeader('Bi-set'));
        widgets.add(_buildExerciseCard(biSet.first));
        widgets.add(_buildExerciseCard(biSet.second));

      case TriSet triSet:
        widgets.add(_buildSetHeader('Tri-set'));
        widgets.add(_buildExerciseCard(triSet.first));
        widgets.add(_buildExerciseCard(triSet.second));
        widgets.add(_buildExerciseCard(triSet.third));
    }

    return widgets;
  }

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
        title: const Text('Editor de treino'),
      ),
      body: _training.sets.isEmpty
          ? const Center(
              child: Text(
                'No exercises added yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                for (int i = 0; i < _training.sets.length; i++)
                  ..._buildSetWidgets(_training.sets[i], i),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        tooltip: 'Add training',
        child: const Icon(Icons.add),
      ),
    );
  }
}
