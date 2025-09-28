import 'package:nice/features/trainning/data/exercise.dart';

class PositionedExercise {
  const PositionedExercise(
    this.value, {
    required this.setIndex,
    required this.position,
  }) : assert(setIndex >= 0),
       assert(position >= 0);

  final int setIndex;
  final int position;
  final Exercise value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PositionedExercise &&
        other.setIndex == setIndex &&
        other.position == position &&
        other.value == value;
  }

  @override
  int get hashCode => setIndex.hashCode ^ position.hashCode ^ value.hashCode;

  @override
  String toString() =>
      '''PositionedExercise(setIndex: $setIndex, position: $position, value: $value)''';

  PositionedExercise copyWith({
    int? setIndex,
    int? position,
    Exercise? value,
  }) {
    return PositionedExercise(
      value ?? this.value,
      setIndex: setIndex ?? this.setIndex,
      position: position ?? this.position,
    );
  }
}
