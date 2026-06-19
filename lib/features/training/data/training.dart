import 'package:flutter/cupertino.dart';
import 'package:nice/core/data/guid_entity.dart';
import 'package:nice/features/training/data/exercise.dart';
import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/exercise_set.dart';

@immutable
class const DailyTraining._({
  required super.id,
  final List<ExerciseSet> sets = const [],
  final DateTime? date,
}) extends GuidEntity {
  factory DailyTraining.create(DateTime date) {
    return ._(id: GuidId(), date: date);
  }

  DailyTraining copyWith({
    List<ExerciseSet>? sets,
    DateTime? date,
  }) {
    return DailyTraining._(
      id: id,
      sets: sets ?? this.sets,
      date: date ?? this.date,
    );
  }

  DailyTraining addExercise(Exercise exercise) {
    final updated = [...sets, ExerciseSet.straight(sets.length, exercise)];
    return copyWith(sets: updated);
  }

  DailyTraining removeExercise(PositionedExercise exercise) {
    final updated = [...sets]..removeExercise(exercise);
    return copyWith(sets: updated);
  }

  DailyTraining mergeExercises(List<PositionedExercise> exercises) {
    final updated = [...sets]..mergeExercises(exercises);
    return copyWith(sets: updated);
  }

  DailyTraining setExercise(PositionedExercise exercise) {
    final updated = [...sets]..setExercise(exercise);
    return copyWith(sets: updated);
  }
}
