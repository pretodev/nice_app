import 'package:flutter/material.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';

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
  });

  final bool selected;
  final StraightSet exerciseSet;
  final ValueChanged<Exercise>? onClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        ExerciseSetItem(
          exercise: exerciseSet.data,
          selected: selected,
          onClicked: onClicked != null
              ? () => onClicked?.call(exerciseSet.data)
              : null,
        ),
        Divider(indent: 8.0, endIndent: 8.0, height: 0.0),
      ],
    );
  }
}

enum BiSetSelectStates {
  none,
  first,
  second,
  all,
}

class BiSetWidget extends StatelessWidget {
  const BiSetWidget({
    super.key,
    required this.exerciseSet,
    this.state = BiSetSelectStates.none,
    this.onFirstClicked,
    this.onSecondClicked,
  });

  final BiSet exerciseSet;
  final BiSetSelectStates state;

  final ValueChanged<Exercise>? onFirstClicked;
  final ValueChanged<Exercise>? onSecondClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Bi-set'),
        ExerciseSetItem(
          exercise: exerciseSet.first,
          selected:
              state == BiSetSelectStates.first ||
              state == BiSetSelectStates.all,
          onClicked: onFirstClicked != null
              ? () => onFirstClicked?.call(exerciseSet.first)
              : null,
        ),
        ExerciseSetItem(
          exercise: exerciseSet.second,
          selected:
              state == BiSetSelectStates.second ||
              state == BiSetSelectStates.all,
          onClicked: onSecondClicked != null
              ? () => onSecondClicked?.call(exerciseSet.second)
              : null,
        ),
        Divider(indent: 8.0, endIndent: 8.0, height: 0.0),
      ],
    );
  }
}

enum TriSetSelectStates {
  none,
  first,
  second,
  third,
  all,
}

class TriSetWidget extends StatelessWidget {
  const TriSetWidget({
    super.key,
    required this.exerciseSet,
    this.seleted = TriSetSelectStates.none,
    this.onFirstClicked,
    this.onSecondClicked,
    this.onThirdClicked,
  });

  final TriSet exerciseSet;
  final TriSetSelectStates seleted;

  final ValueChanged<Exercise>? onFirstClicked;
  final ValueChanged<Exercise>? onSecondClicked;
  final ValueChanged<Exercise>? onThirdClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Tri-set'),
        ExerciseSetItem(
          exercise: exerciseSet.first,
          selected:
              seleted == TriSetSelectStates.first ||
              seleted == TriSetSelectStates.all,
          onClicked: onFirstClicked != null
              ? () => onFirstClicked?.call(exerciseSet.first)
              : null,
        ),
        ExerciseSetItem(
          exercise: exerciseSet.second,
          selected:
              seleted == TriSetSelectStates.second ||
              seleted == TriSetSelectStates.all,
          onClicked: onSecondClicked != null
              ? () => onSecondClicked?.call(exerciseSet.second)
              : null,
        ),
        ExerciseSetItem(
          exercise: exerciseSet.third,
          selected:
              seleted == TriSetSelectStates.third ||
              seleted == TriSetSelectStates.all,
          onClicked: onThirdClicked != null
              ? () => onThirdClicked?.call(exerciseSet.third)
              : null,
        ),
        Divider(indent: 8.0, endIndent: 8.0, height: 0.0),
      ],
    );
  }
}

class ExerciseSetItem extends StatelessWidget {
  const ExerciseSetItem({
    super.key,
    required this.exercise,
    this.onClicked,
    this.selected = false,
  });

  final Exercise exercise;
  final bool selected;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    var color = Colors.transparent;
    if (selected) {
      color = Colors.blue[100]!;
    }
    if (onClicked == null) {
      color = Colors.black12;
    }

    return GestureDetector(
      onTap: onClicked,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
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
