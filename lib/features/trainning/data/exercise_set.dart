import 'exercise.dart';
import 'exercise_positioned.dart';

sealed class ExerciseSet {
  factory ExerciseSet.straight(
    int index,
    Exercise exercise,
  ) {
    return StraightSet(index, exercise);
  }

  factory ExerciseSet.bi(
    int index, {
    required Exercise first,
    required Exercise second,
  }) {
    return BiSet(index, first, second);
  }

  factory ExerciseSet.tri(
    int index, {
    required Exercise first,
    required Exercise second,
    required Exercise third,
  }) {
    return TriSet(index, first, second, third);
  }

  const ExerciseSet();
}

class StraightSet extends ExerciseSet {
  StraightSet(this.index, this._data);

  final int index;
  final Exercise _data;

  PositionedExercise get data => PositionedExercise(
    _data,
    externalIndex: index,
    internalIndex: 0,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StraightSet && other.index == index && other._data == _data;
  }

  @override
  int get hashCode => index.hashCode ^ _data.hashCode;

  @override
  String toString() => '''StraightSet(index: $index, data: $_data)''';

  StraightSet copyWith({
    int? index,
    Exercise? data,
  }) {
    return StraightSet(
      index ?? this.index,
      data ?? _data,
    );
  }
}

class BiSet extends ExerciseSet {
  BiSet(this.index, this._first, this._second);

  final int index;
  final Exercise _first;
  final Exercise _second;

  PositionedExercise get first => PositionedExercise(
    _first,
    externalIndex: index,
    internalIndex: 0,
  );

  PositionedExercise get second => PositionedExercise(
    _second,
    externalIndex: index,
    internalIndex: 1,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BiSet &&
        other.index == index &&
        other._first == _first &&
        other._second == _second;
  }

  @override
  int get hashCode => index.hashCode ^ _first.hashCode ^ _second.hashCode;

  @override
  String toString() =>
      '''BiSet(index: $index, first: $_first, second: $_second)''';

  BiSet copyWith({
    int? index,
    Exercise? first,
    Exercise? second,
  }) {
    return BiSet(
      index ?? this.index,
      first ?? _first,
      second ?? _second,
    );
  }
}

class TriSet extends ExerciseSet {
  TriSet(this.index, this._first, this._second, this._third);

  final int index;
  final Exercise _first;
  final Exercise _second;
  final Exercise _third;

  PositionedExercise get first => PositionedExercise(
    _first,
    externalIndex: index,
    internalIndex: 0,
  );

  PositionedExercise get second => PositionedExercise(
    _second,
    externalIndex: index,
    internalIndex: 1,
  );

  PositionedExercise get third => PositionedExercise(
    _third,
    externalIndex: index,
    internalIndex: 2,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TriSet &&
        other.index == index &&
        other._first == _first &&
        other._second == _second &&
        other._third == _third;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        _first.hashCode ^
        _second.hashCode ^
        _third.hashCode;
  }

  @override
  String toString() {
    return '''TriSet(index: $index, _first: $_first, _second: $_second, _third: $_third)''';
  }

  TriSet copyWith({
    int? index,
    Exercise? first,
    Exercise? second,
    Exercise? third,
  }) {
    return TriSet(
      index ?? this.index,
      first ?? _first,
      second ?? _second,
      third ?? _third,
    );
  }
}

extension ExerciseSetListExtension on List<ExerciseSet> {
  List<PositionedExercise> get exercises => expand(
    (s) => switch (s) {
      StraightSet() => [s.data],
      BiSet() => [s.first, s.second],
      TriSet() => [s.first, s.second, s.third],
    },
  ).toList();

  void _updateIndexes() {
    for (var i = 0; i < length; i++) {
      final set = this[i];
      final newSet = switch (set) {
        StraightSet() => set.copyWith(index: i),
        BiSet() => set.copyWith(index: i),
        TriSet() => set.copyWith(index: i),
      };
      this[i] = newSet;
    }
  }

  void removeExercise(PositionedExercise exercise) {
    final target = this[exercise.externalIndex];
    if (target is StraightSet) {
      removeAt(exercise.externalIndex);
      return _updateIndexes();
    }

    if (target is BiSet) {
      final selected = exercise.internalIndex == 0
          ? target.second
          : target.first;
      this[exercise.externalIndex] = StraightSet(
        exercise.externalIndex,
        selected.value,
      );
      return;
    }

    if (target is TriSet) {
      final [first, second] = exercise.internalIndex == 0
          ? [target.second, target.third]
          : exercise.internalIndex == 1
          ? [target.first, target.third]
          : [target.first, target.second];
      this[exercise.externalIndex] = BiSet(
        exercise.externalIndex,
        first.value,
        second.value,
      );
      return;
    }
  }

  ExerciseSet _mergeSets(ExerciseSet a, ExerciseSet b) {
    if (a is StraightSet && b is StraightSet) {
      return BiSet(a.index, a.data.value, b.data.value);
    }
    if (a is BiSet && b is StraightSet) {
      return TriSet(a.index, a.first.value, a.second.value, b.data.value);
    }
    if (b is BiSet && a is StraightSet) {
      return TriSet(a.index, a.data.value, b.first.value, b.second.value);
    }
    throw Exception('Cannot merge $a with $b');
  }

  void mergeExercises(List<PositionedExercise> exercises) {
    if (exercises.length < 2) {
      return;
    }
    if (exercises.length > 3) {
      throw Exception('Cannot merge more than three exercises');
    }
    exercises.sort((a, b) => a.externalIndex.compareTo(b.externalIndex));
    for (var i = 0; i < exercises.length - 1; i++) {
      final a = exercises[i];
      final b = exercises[i + 1];
      final merged = _mergeSets(this[a.externalIndex], this[b.externalIndex]);
      this[a.externalIndex] = merged;
      removeAt(b.externalIndex);
    }
    _updateIndexes();
  }
}
