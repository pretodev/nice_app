import 'package:flutter/material.dart';
import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/ui/widgets/exercise_set_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class TrainingEditorBody extends StatelessWidget {
  const TrainingEditorBody({
    super.key,
    required this.value,
    this.onExerciseClicked,
    this.onExerciseLongPressed,
  });

  final AsyncValue<DailyTraining> value;
  final ValueChanged<PositionedExercise>? onExerciseClicked;
  final ValueChanged<PositionedExercise>? onExerciseLongPressed;

  @override
  Widget build(BuildContext context) {
    if (value.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (value.hasError) {
      return Center(child: Text(value.error.toString()));
    }

    final training = value.requireValue;

    if (training.sets.isEmpty) {
      return const Center(
        child: Text(
          'Sem exercícios',
          style: TextStyle(fontSize: 16, color: Colors.grey),
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
            selected: training.selector.has(set.data),
            onClicked: onExerciseClicked,
            onLongPressed: onExerciseLongPressed,
          ),
          BiSet() => BiSetWidget(
            exerciseSet: set,
            firstSelected: training.selector.has(set.first),
            secondSelected: training.selector.has(set.second),
            onFirstClicked: onExerciseClicked,
            onFirstLongPressed: onExerciseLongPressed,
            onSecondClicked: onExerciseClicked,
            onSecondLongPressed: onExerciseLongPressed,
          ),
          TriSet() => TriSetWidget(
            exerciseSet: set,
            firstSelected: training.selector.has(set.first),
            secondSelected: training.selector.has(set.second),
            thirdSelected: training.selector.has(set.third),
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
