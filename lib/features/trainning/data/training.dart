import '../../../core/data/entity.dart';
import 'exercise.dart';
import 'exercise_positioned.dart';
import 'exercise_set.dart';
import 'training_selector.dart';

class Training extends Entity {
  Training({
    super.id,
    List<ExerciseSet>? sets,
    this.date,
  }) : _sets = sets ?? [] {
    selector = TrainingSelector(_sets);
  }

  DateTime? date;
  late final TrainingSelector selector;

  final List<ExerciseSet> _sets;

  List<ExerciseSet> get sets => _sets;

  void addExercise(Exercise exercise) {
    _sets.add(ExerciseSet.straight(_sets.length, exercise));
  }

  void removeExercise(PositionedExercise exercise) {
    _sets.removeExercise(exercise);
  }

  void mergeExercises(List<PositionedExercise> exercises) {
    _sets.mergeExercises(exercises);
  }

  void setExercise(PositionedExercise exercise) {
    final target = _sets[exercise.externalIndex];
    final editing = switch (target) {
      StraightSet() => target.copyWith(data: exercise.value),
      BiSet() =>
        exercise.internalIndex == 0
            ? target.copyWith(first: exercise.value)
            : target.copyWith(second: exercise.value),
      TriSet() =>
        exercise.internalIndex == 0
            ? target.copyWith(first: exercise.value)
            : exercise.internalIndex == 1
            ? target.copyWith(second: exercise.value)
            : target.copyWith(third: exercise.value),
    };
    _sets[exercise.externalIndex] = editing;
  }
}
