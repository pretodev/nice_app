import 'package:flutter/material.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';

typedef ExerciseSetItemClicked = void Function(Exercise exercise, int index);

class ExerciseSetWidget extends StatelessWidget {
  const ExerciseSetWidget({
    super.key,
    required this.set,
    this.onExerciseClicked,
    this.selectedIndex,
    this.waitingMergeIndex,
  });

  final ExerciseSet set;
  final int? selectedIndex;
  final int? waitingMergeIndex;
  final ExerciseSetItemClicked? onExerciseClicked;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(indent: 8.0, endIndent: 8.0, height: 0.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: switch (set) {
        StraightSet(data: final e) => [
          ExerciseSetItem(
            exercise: e,
            selected: selectedIndex == 0,
            waitingMerge: waitingMergeIndex == 0,
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
            selected: selectedIndex == 0,
            waitingMerge: waitingMergeIndex == 0,
            onClicked: onExerciseClicked != null
                ? () => onExerciseClicked?.call(first, 0)
                : null,
          ),
          ExerciseSetItem(
            exercise: second,
            selected: selectedIndex == 1,
            waitingMerge: waitingMergeIndex == 1,
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
              selected: selectedIndex == 0,
              waitingMerge: waitingMergeIndex == 0,
              onClicked: onExerciseClicked != null
                  ? () => onExerciseClicked?.call(first, 0)
                  : null,
            ),
            ExerciseSetItem(
              exercise: second,
              selected: selectedIndex == 1,
              waitingMerge: waitingMergeIndex == 1,
              onClicked: onExerciseClicked != null
                  ? () => onExerciseClicked?.call(second, 1)
                  : null,
            ),
            ExerciseSetItem(
              exercise: third,
              selected: selectedIndex == 2,
              waitingMerge: waitingMergeIndex == 2,
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
  const ExerciseSetItem({
    super.key,
    required this.exercise,
    this.onClicked,
    this.selected = false,
    this.waitingMerge = false,
  });

  final Exercise exercise;
  final bool selected;
  final bool waitingMerge;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    var color = Colors.transparent;
    if (selected) {
      color = Colors.blue[100]!;
    }
    if (waitingMerge) {
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
                color: waitingMerge ? Colors.grey : null,
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
