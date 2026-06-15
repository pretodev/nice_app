import 'package:flutter/foundation.dart';

sealed class const ExerciseExecution() {
  String get formatted;
}

class TimedExerciseExecution(final Duration duration) extends ExerciseExecution {
  @override
  String get formatted =>
      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

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
class const SerializedExerciseExecution(final List<int> repeats)
    extends ExerciseExecution {
  factory SerializedExerciseExecution.initial() {
    return const SerializedExerciseExecution([12, 12, 12]);
  }

  bool get isAllEquals {
    if (repeats.isEmpty) {
      return false;
    }
    var allEquals = true;
    for (var i = 0; i < repeats.length; i++) {
      if (repeats[i] != repeats[0]) {
        allEquals = false;
        break;
      }
    }
    return allEquals;
  }

  int get countSeries => repeats.length;

  @override
  String get formatted => '$countSeries Séries x ${repeats.first} reps';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SerializedExerciseExecution &&
        listEquals(other.repeats, repeats);
  }

  @override
  int get hashCode => repeats.hashCode;

  SerializedExerciseExecution copyWith({List<int>? repeats}) {
    return SerializedExerciseExecution(repeats ?? this.repeats);
  }

  @override
  String toString() => '''SerializedExerciseExecution(repeats: $repeats)''';
}
