import 'exercise.dart';

class PositionedExercise {
  const PositionedExercise(
    this.value, {
    required this.externalIndex,
    required this.internalIndex,
  }) : assert(externalIndex >= 0),
       assert(internalIndex >= 0);

  final int externalIndex;
  final int internalIndex;
  final Exercise value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PositionedExercise &&
        other.externalIndex == externalIndex &&
        other.internalIndex == internalIndex &&
        other.value == value;
  }

  @override
  int get hashCode =>
      externalIndex.hashCode ^ internalIndex.hashCode ^ value.hashCode;

  @override
  String toString() =>
      '''PositionedExercise(externalIndex: $externalIndex, internalIndex: $internalIndex, value: $value)''';

  PositionedExercise copyWith({
    int? externalIndex,
    int? internalIndex,
    Exercise? value,
  }) {
    return PositionedExercise(
      value ?? this.value,
      externalIndex: externalIndex ?? this.externalIndex,
      internalIndex: internalIndex ?? this.internalIndex,
    );
  }
}
