import 'package:flutter/material.dart';

import 'exercise_execution.dart';

@immutable
class Exercise {
  factory Exercise.empty() {
    return Exercise(name: '', execution: SerializedExerciseExecution.initial());
  }

  const Exercise({
    required this.name,
    required this.execution,
    this.observation,
    this.load,
  });

  final String name;
  final ExerciseExecution execution;
  final String? observation;
  final double? load;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Exercise &&
        other.name == name &&
        other.execution == execution &&
        other.observation == observation &&
        other.load == load;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        execution.hashCode ^
        observation.hashCode ^
        load.hashCode;
  }

  @override
  String toString() {
    return '''Exercise(name: $name, execution: $execution, observation: $observation, load: $load)''';
  }
}
