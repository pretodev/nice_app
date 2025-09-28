import 'package:flutter/material.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';

typedef ExerciseSetItemClicked = void Function(Exercise exercise, int index);

class ExerciseSetWidget extends StatelessWidget {
  const ExerciseSetWidget({
    super.key,
    required this.set,
    this.onExerciseClicked,
  });

  final ExerciseSet set;
  final ExerciseSetItemClicked? onExerciseClicked;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(indent: 8.0, endIndent: 8.0, height: 0.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: switch (set) {
        StraightSet(data: final e) => [
          ExerciseSetItem(
            exercise: e,
            onClicked: onExerciseClicked != null
                ? () => onExerciseClicked?.call(e, 0)
                : null,
          ),
          divider,
        ],
        BiSet(first: final first, second: final second) => [
          Text('Bi-set'),
          ExerciseSetItem(
            exercise: first,
            onClicked: onExerciseClicked != null
                ? () => onExerciseClicked?.call(first, 0)
                : null,
          ),
          ExerciseSetItem(
            exercise: second,
            onClicked: onExerciseClicked != null
                ? () => onExerciseClicked?.call(second, 1)
                : null,
          ),
          divider,
        ],
        TriSet(
          first: final first,
          second: final second,
          third: final third,
        ) =>
          [
            Text('Tri-set'),
            ExerciseSetItem(
              exercise: first,
              onClicked: onExerciseClicked != null
                  ? () => onExerciseClicked?.call(first, 0)
                  : null,
            ),
            ExerciseSetItem(
              exercise: second,
              onClicked: onExerciseClicked != null
                  ? () => onExerciseClicked?.call(second, 1)
                  : null,
            ),
            ExerciseSetItem(
              exercise: third,
              onClicked: onExerciseClicked != null
                  ? () => onExerciseClicked?.call(third, 2)
                  : null,
            ),
            divider,
          ],
      },
    );
  }
}

class ExerciseSetItem extends StatelessWidget {
  const ExerciseSetItem({super.key, required this.exercise, this.onClicked});

  final Exercise exercise;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 2.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
