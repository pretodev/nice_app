import 'package:flutter/material.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';

class ExerciseSetWidget extends StatelessWidget {
  const ExerciseSetWidget({
    super.key,
    required this.set,
  });

  final ExerciseSet set;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: switch (set) {
        StraightSet(data: final e) => [
          ExerciseSetItem(exercise: e),
          Divider(indent: 8.0, endIndent: 8.0),
        ],
        BiSet(first: final first, second: final second) => [
          Text('Bi-set'),
          ExerciseSetItem(exercise: first),
          ExerciseSetItem(exercise: second),
          Divider(indent: 8.0, endIndent: 8.0),
        ],
        TriSet(
          first: final first,
          second: final second,
          third: final third,
        ) =>
          [
            Text('Tri-set'),
            ExerciseSetItem(exercise: first),
            ExerciseSetItem(exercise: second),
            ExerciseSetItem(exercise: third),
            Divider(indent: 8.0, endIndent: 8.0),
          ],
      },
    );
  }
}

class ExerciseSetItem extends StatelessWidget {
  const ExerciseSetItem({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
