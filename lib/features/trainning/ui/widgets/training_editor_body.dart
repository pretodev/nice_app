import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/exercise_positioned.dart';
import '../../data/exercise_set.dart';
import '../../data/training.dart';
import 'exercise_set_widget.dart';

class TrainingEditorBody extends StatelessWidget {
  const TrainingEditorBody({
    super.key,
    required this.value,
    this.selected,
    this.onExerciseClicked,
    this.onExerciseLongPressed,
  });

  final AsyncValue<Training> value;
  final PositionedExercise? selected;
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
            selected: selected?.setIndex == index,
            onClicked: (exercise) => onExerciseClicked?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 0,
              ),
            ),
            onLongPressed: (exercise) => onExerciseLongPressed?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 0,
              ),
            ),
          ),
          BiSet() => BiSetWidget(
            exerciseSet: set,
            onFirstClicked: (exercise) => onExerciseClicked?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 0,
              ),
            ),
            onFirstLongPressed: (exercise) => onExerciseLongPressed?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 0,
              ),
            ),
            onSecondClicked: (exercise) => onExerciseClicked?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 1,
              ),
            ),
            onSecondLongPressed: (exercise) => onExerciseLongPressed?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 1,
              ),
            ),
          ),
          TriSet() => TriSetWidget(
            exerciseSet: set,
            onFirstClicked: (exercise) => onExerciseClicked?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 0,
              ),
            ),
            onFirstLongPressed: (exercise) => onExerciseLongPressed?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 0,
              ),
            ),
            onSecondClicked: (exercise) => onExerciseClicked?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 1,
              ),
            ),
            onSecondLongPressed: (exercise) => onExerciseLongPressed?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 1,
              ),
            ),
            onThirdClicked: (exercise) => onExerciseClicked?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 2,
              ),
            ),
            onThirdLongPressed: (exercise) => onExerciseLongPressed?.call(
              PositionedExercise(
                exercise,
                setIndex: index,
                position: 2,
              ),
            ),
          ),
        };
      },
    );
  }
}
