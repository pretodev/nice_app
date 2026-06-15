import 'package:flutter/material.dart';
import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/exercise_set.dart';
import 'package:nice/features/training/data/training_status.dart';
import 'package:nice/features/training/state/training_view_model.dart';
import 'package:nice/features/training/ui/widgets/exercise_set_widget.dart';

class TrainingEditorBody extends StatelessWidget {
  const TrainingEditorBody({
    super.key,
    required this.state,
    this.onExerciseClicked,
    this.onExerciseLongPressed,
  });

  final TrainingState state;
  final ValueChanged<PositionedExercise>? onExerciseClicked;
  final ValueChanged<PositionedExercise>? onExerciseLongPressed;

  @override
  Widget build(BuildContext context) {
    if (state.status == TrainingStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TrainingStatus.error) {
      // TODO: Improve error message
      return const Center(child: Text('Error loading training'));
    }

    if (state.training == null) {
      return const SizedBox.shrink();
    }

    final training = state.training!;

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
