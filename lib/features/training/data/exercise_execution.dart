import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

sealed class const ExerciseExecution() extends Equatable {
  String get formatted;
}

class const TimedExerciseExecution(final Duration duration)
    extends ExerciseExecution {
  @override
  String get formatted =>
      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [duration];
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
  List<Object?> get props => [repeats];
}
