import 'package:flutter/material.dart';

import '../../data/exercise.dart';
import '../../data/exercise_positioned.dart';
import '../../data/exercise_set.dart';

typedef ExerciseSetItemClicked = void Function(Exercise exercise, int position);

enum ExerciseSetState {
  standard,
  disabled,
  selected,
}

class StraightSetWidget extends StatelessWidget {
  const StraightSetWidget({
    super.key,
    required this.exerciseSet,
    this.selected = false,
    this.onClicked,
    this.onLongPressed,
  });

  final bool selected;
  final StraightSet exerciseSet;
  final ValueChanged<PositionedExercise>? onClicked;
  final ValueChanged<PositionedExercise>? onLongPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExerciseSetItem(
            exercise: exerciseSet.data.value,
            selected: selected,
            onClicked: onClicked != null
                ? () => onClicked?.call(exerciseSet.data)
                : null,
            onLongPress: onLongPressed != null
                ? () => onLongPressed?.call(exerciseSet.data)
                : null,
          ),
        ],
      ),
    );
  }
}

class BiSetWidget extends StatelessWidget {
  const BiSetWidget({
    super.key,
    required this.exerciseSet,
    this.firstSelected = false,
    this.secondSelected = false,
    this.onFirstClicked,
    this.onSecondClicked,
    this.onFirstLongPressed,
    this.onSecondLongPressed,
  });

  final BiSet exerciseSet;
  final bool firstSelected;
  final bool secondSelected;

  final ValueChanged<PositionedExercise>? onFirstClicked;
  final ValueChanged<PositionedExercise>? onSecondClicked;
  final ValueChanged<PositionedExercise>? onFirstLongPressed;
  final ValueChanged<PositionedExercise>? onSecondLongPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 12.0,
            ),
            child: Text('Bi-set'),
          ),
          ExerciseSetItem(
            exercise: exerciseSet.first.value,
            selected: firstSelected,
            onClicked: onFirstClicked != null
                ? () => onFirstClicked?.call(exerciseSet.first)
                : null,
            onLongPress: onFirstLongPressed != null
                ? () => onFirstLongPressed?.call(exerciseSet.first)
                : null,
          ),
          ExerciseSetItem(
            exercise: exerciseSet.second.value,
            selected: secondSelected,
            onClicked: onSecondClicked != null
                ? () => onSecondClicked?.call(exerciseSet.second)
                : null,
            onLongPress: onSecondLongPressed != null
                ? () => onSecondLongPressed?.call(exerciseSet.second)
                : null,
          ),
        ],
      ),
    );
  }
}

class TriSetWidget extends StatelessWidget {
  const TriSetWidget({
    super.key,
    required this.exerciseSet,
    this.firstSelected = false,
    this.secondSelected = false,
    this.thirdSelected = false,
    this.onFirstClicked,
    this.onSecondClicked,
    this.onThirdClicked,
    this.onFirstLongPressed,
    this.onSecondLongPressed,
    this.onThirdLongPressed,
  });

  final TriSet exerciseSet;
  final bool firstSelected;
  final bool secondSelected;
  final bool thirdSelected;

  final ValueChanged<PositionedExercise>? onFirstClicked;
  final ValueChanged<PositionedExercise>? onSecondClicked;
  final ValueChanged<PositionedExercise>? onThirdClicked;
  final ValueChanged<PositionedExercise>? onFirstLongPressed;
  final ValueChanged<PositionedExercise>? onSecondLongPressed;
  final ValueChanged<PositionedExercise>? onThirdLongPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 12.0,
            ),
            child: Text('Tri-set'),
          ),
          ExerciseSetItem(
            exercise: exerciseSet.first.value,
            selected: firstSelected,
            onClicked: onFirstClicked != null
                ? () => onFirstClicked?.call(exerciseSet.first)
                : null,
            onLongPress: onFirstLongPressed != null
                ? () => onFirstLongPressed?.call(exerciseSet.first)
                : null,
          ),
          ExerciseSetItem(
            exercise: exerciseSet.second.value,
            selected: secondSelected,
            onClicked: onSecondClicked != null
                ? () => onSecondClicked?.call(exerciseSet.second)
                : null,
            onLongPress: onSecondLongPressed != null
                ? () => onSecondLongPressed?.call(exerciseSet.second)
                : null,
          ),
          ExerciseSetItem(
            exercise: exerciseSet.third.value,
            selected: thirdSelected,
            onClicked: onThirdClicked != null
                ? () => onThirdClicked?.call(exerciseSet.third)
                : null,
            onLongPress: onThirdLongPressed != null
                ? () => onThirdLongPressed?.call(exerciseSet.third)
                : null,
          ),
        ],
      ),
    );
  }
}

class ExerciseSetItem extends StatelessWidget {
  const ExerciseSetItem({
    super.key,
    required this.exercise,
    this.onClicked,
    this.selected = false,
    this.onLongPress,
  });

  final Exercise exercise;
  final bool selected;
  final VoidCallback? onClicked;
  final VoidCallback? onLongPress;

  Color get backgroundColor {
    if (selected) {
      return Colors.blue[100]!;
    }

    if (onClicked == null) {
      return Colors.black12;
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Column(
          spacing: 2.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: onClicked == null ? Colors.grey : null,
              ),
            ),
            Text(
              exercise.execution.formatted,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
