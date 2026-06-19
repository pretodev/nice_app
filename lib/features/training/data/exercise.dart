import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nice/features/training/data/exercise_execution.dart';

@immutable
class const Exercise({
  required final String name,
  required final ExerciseExecution execution,
  final String? observation,
  final double? load,
}) extends Equatable {
  factory Exercise.empty() {
    return Exercise(name: '', execution: SerializedExerciseExecution.initial());
  }

  @override
  List<Object?> get props => [name, execution, observation, load];
}
