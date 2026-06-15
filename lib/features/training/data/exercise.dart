import 'package:flutter/material.dart';
import 'package:nice/features/training/data/exercise_execution.dart';

@immutable
class const Exercise({
  required final String name,
  required final ExerciseExecution execution,
  final String? observation,
  final double? load,
}) {
  factory Exercise.empty() {
    return Exercise(name: '', execution: SerializedExerciseExecution.initial());
  }

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
