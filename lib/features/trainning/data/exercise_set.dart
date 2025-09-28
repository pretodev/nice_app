import 'package:nice/features/trainning/data/exercise.dart';

sealed class ExerciseSet {
  factory ExerciseSet.straightSet(
    Exercise exercise,
  ) {
    return StraightSet(exercise);
  }

  factory ExerciseSet.biSet(
    Exercise first,
    Exercise second,
  ) {
    return BiSet(first, second);
  }

  factory ExerciseSet.triSet(
    Exercise first,
    Exercise second,
    Exercise third,
  ) {
    return TriSet(first, second, third);
  }

  const ExerciseSet();

  List<Exercise> toList();

  int get length => toList().length;
}

class StraightSet extends ExerciseSet {
  StraightSet(this.data);

  final Exercise data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StraightSet && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;

  @override
  List<Exercise> toList() => [data];

  @override
  String toString() => '''StraightSet(data: $data)''';
}

class BiSet extends ExerciseSet {
  BiSet(this.first, this.second);

  final Exercise first;
  final Exercise second;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BiSet && other.first == first && other.second == second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  List<Exercise> toList() => [first, second];

  @override
  String toString() => '''BiSet(first: $first, second: $second)''';
}

class TriSet extends ExerciseSet {
  TriSet(this.first, this.second, this.third);

  final Exercise first;
  final Exercise second;
  final Exercise third;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TriSet &&
        other.first == first &&
        other.second == second &&
        other.third == third;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;

  @override
  List<Exercise> toList() => [first, second, third];

  @override
  String toString() =>
      '''TriSet(first: $first, second: $second, third: $third)''';
}
