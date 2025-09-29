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

enum BiSetWidgetState {
  standard,
  firstSelected,
  secondSelected,
  allSelected,
}

class BiSetWidget extends StatelessWidget {
  const BiSetWidget({
    super.key,
    required this.exerciseSet,
    this.state = BiSetWidgetState.standard,
    this.onFirstClicked,
    this.onSecondClicked,
  });

  final BiSet exerciseSet;
  final BiSetWidgetState state;

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
              state == BiSetWidgetState.firstSelected ||
              state == BiSetWidgetState.allSelected,
          onClicked: onFirstClicked != null
              ? () => onFirstClicked?.call(exerciseSet.first)
              : null,
        ),
        ExerciseSetItem(
          exercise: exerciseSet.second,
          selected:
              state == BiSetWidgetState.secondSelected ||
              state == BiSetWidgetState.allSelected,
          onClicked: onSecondClicked != null
              ? () => onSecondClicked?.call(exerciseSet.second)
              : null,
        ),
        Divider(indent: 8.0, endIndent: 8.0, height: 0.0),
      ],
    );
  }
}

enum TriSetWidgetState {
  standard,
  firstSelected,
  secondSelected,
  thirdSelected,
  allSelected,
}

class TriSetWidget extends StatelessWidget {
  const TriSetWidget({
    super.key,
    required this.exerciseSet,
    this.state = TriSetWidgetState.standard,
    this.onFirstClicked,
    this.onSecondClicked,
    this.onThirdClicked,
  });

  final TriSet exerciseSet;
  final TriSetWidgetState state;

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
              state == TriSetWidgetState.firstSelected ||
              state == TriSetWidgetState.allSelected,
          onClicked: onFirstClicked != null
              ? () => onFirstClicked?.call(exerciseSet.first)
              : null,
        ),
        ExerciseSetItem(
          exercise: exerciseSet.second,
          selected:
              state == TriSetWidgetState.secondSelected ||
              state == TriSetWidgetState.allSelected,
          onClicked: onSecondClicked != null
              ? () => onSecondClicked?.call(exerciseSet.second)
              : null,
        ),
        ExerciseSetItem(
          exercise: exerciseSet.third,
          selected:
              state == TriSetWidgetState.thirdSelected ||
              state == TriSetWidgetState.allSelected,
          onClicked: onThirdClicked != null
              ? () => onThirdClicked?.call(exerciseSet.third)
              : null,
        ),
        Divider(indent: 8.0, endIndent: 8.0, height: 0.0),
      ],
    );
  }
}

// class ExerciseSetWidget extends StatelessWidget {
//   const ExerciseSetWidget({
//     super.key,
//     required this.set,
//     this.state = ExerciseSetState.standard,
//     this.onExerciseClicked,
//   });

//   final ExerciseSetState state;

//   final ExerciseSet set;
//   final ExerciseSetItemClicked? onExerciseClicked;

//   @override
//   Widget build(BuildContext context) {
//     final divider = Divider(indent: 8.0, endIndent: 8.0, height: 0.0);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: switch (set) {
//         StraightSet(data: final e) => [
//           ExerciseSetItem(
//             exercise: e,
//             selected: selectedIndex == 0,
//             waitingMerge: waitingMergeIndex == 0,
//             onClicked: onExerciseClicked != null
//                 ? () => onExerciseClicked?.call(e, 0)
//                 : null,
//           ),
//           divider,
//         ],
//         BiSet(first: final first, second: final second) => [
//           Text('Bi-set'),
//           ExerciseSetItem(
//             exercise: first,
//             selected: selectedIndex == 0,
//             waitingMerge: waitingMergeIndex == 0,
//             onClicked: onExerciseClicked != null
//                 ? () => onExerciseClicked?.call(first, 0)
//                 : null,
//           ),
//           ExerciseSetItem(
//             exercise: second,
//             selected: selectedIndex == 1,
//             waitingMerge: waitingMergeIndex == 1,
//             onClicked: onExerciseClicked != null
//                 ? () => onExerciseClicked?.call(second, 1)
//                 : null,
//           ),
//           divider,
//         ],
//         TriSet(
//           first: final first,
//           second: final second,
//           third: final third,
//         ) =>
//           [
//             Text('Tri-set'),
//             ExerciseSetItem(
//               exercise: first,
//               selected: selectedIndex == 0,
//               waitingMerge: waitingMergeIndex == 0,
//               onClicked: onExerciseClicked != null
//                   ? () => onExerciseClicked?.call(first, 0)
//                   : null,
//             ),
//             ExerciseSetItem(
//               exercise: second,
//               selected: selectedIndex == 1,
//               waitingMerge: waitingMergeIndex == 1,
//               onClicked: onExerciseClicked != null
//                   ? () => onExerciseClicked?.call(second, 1)
//                   : null,
//             ),
//             ExerciseSetItem(
//               exercise: third,
//               selected: selectedIndex == 2,
//               waitingMerge: waitingMergeIndex == 2,
//               onClicked: onExerciseClicked != null
//                   ? () => onExerciseClicked?.call(third, 2)
//                   : null,
//             ),
//             divider,
//           ],
//       },
//     );
//   }
// }

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
