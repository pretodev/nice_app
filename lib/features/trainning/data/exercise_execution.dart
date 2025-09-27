import 'package:flutter/foundation.dart';

sealed class ExerciseExecution {
  const ExerciseExecution();
}

class TimedExerciseExecution extends ExerciseExecution {
  final Duration duration;

  TimedExerciseExecution(this.duration);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimedExerciseExecution && other.duration == duration;
  }

  @override
  int get hashCode => duration.hashCode;

  @override
  String toString() => '''TimedExerciseExecution(duration: $duration)''';
}

@immutable
class SerializedExerciseExecution extends ExerciseExecution {
  final List<int> repeats;

  const SerializedExerciseExecution(this.repeats);

  bool get isAllEquals {
    if (repeats.isEmpty) {
      return false;
    }
    bool allEquals = true;
    for (int i = 0; i < repeats.length; i++) {
      if (repeats[i] != repeats[0]) {
        allEquals = false;
        break;
      }
    }
    return allEquals;
  }

  int get countSeries => repeats.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SerializedExerciseExecution &&
        listEquals(other.repeats, repeats);
  }

  @override
  int get hashCode => repeats.hashCode;

  SerializedExerciseExecution copyWith({
    List<int>? repeats,
  }) {
    return SerializedExerciseExecution(
      repeats ?? this.repeats,
    );
  }

  @override
  String toString() => '''SerializedExerciseExecution(repeats: $repeats)''';
}
