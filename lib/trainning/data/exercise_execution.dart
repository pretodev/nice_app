import 'package:flutter/foundation.dart';

sealed class ExerciseExecution {}

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
}

class SerializedExerciseExecution extends ExerciseExecution {
  final List<int> repeats;

  SerializedExerciseExecution(this.repeats);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SerializedExerciseExecution &&
        listEquals(other.repeats, repeats);
  }

  @override
  int get hashCode => repeats.hashCode;
}
