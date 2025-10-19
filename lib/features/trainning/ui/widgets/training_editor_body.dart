import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/exercise_positioned.dart';
import '../../data/exercise_set.dart';
import '../../data/training.dart';
import '../../data/training_selector.dart';
import 'exercise_set_widget.dart';

class TrainingEditorBody extends StatelessWidget {
  const TrainingEditorBody({
    super.key,
    required this.value,
    this.selector,
    this.onExerciseClicked,
    this.onExerciseLongPressed,
  });

  final AsyncValue<Training> value;
  final TrainingSelector? selector;
  final ValueChanged<PositionedExercise>? onExerciseClicked;
  final ValueChanged<PositionedExercise>? onExerciseLongPressed;

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (value.hasError) {
      return Center(
        child: Text(value.error.toString()),
      );
    }

    final training = value.value!;

    if (training.sets.isEmpty) {
      return const Center(
        child: Text(
          'Sem exercícios',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: training.sets.length,
      itemBuilder: (context, index) {
        final set = training.sets[index];
        return switch (set) {
          StraightSet() => StraightSetWidget(
            exerciseSet: set,
            selected: selector?.has(set.data) ?? false,
            onClicked: onExerciseClicked,
            onLongPressed: onExerciseLongPressed,
          ),
          BiSet() => BiSetWidget(
            exerciseSet: set,
            onFirstClicked: onExerciseClicked,
            onFirstLongPressed: onExerciseLongPressed,
            onSecondClicked: onExerciseClicked,
            onSecondLongPressed: onExerciseLongPressed,
          ),
          TriSet() => TriSetWidget(
            exerciseSet: set,
            onFirstClicked: onExerciseClicked,
            onFirstLongPressed: onExerciseLongPressed,
            onSecondClicked: onExerciseClicked,
            onSecondLongPressed: onExerciseLongPressed,
            onThirdClicked: onExerciseClicked,
            onThirdLongPressed: onExerciseLongPressed,
          ),
        };
      },
    );
  }
}
