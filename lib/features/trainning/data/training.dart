import 'package:odu_core/odu_core.dart';

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
    _selector = TrainingSelector(_sets);
  }

  DateTime? date;

  late TrainingSelector _selector;

  TrainingSelector get selector => _selector;

  final List<ExerciseSet> _sets;

  List<ExerciseSet> get sets => _sets;

  void addExercise(Exercise exercise) {
    _sets.add(ExerciseSet.straight(_sets.length, exercise));
    _selector = TrainingSelector(_sets);
  }

  void removeExercise(PositionedExercise exercise) {
    _sets.removeExercise(exercise);
    _selector = TrainingSelector(_sets);
  }

  void mergeExercises(List<PositionedExercise> exercises) {
    _sets.mergeExercises(exercises);
    _selector = TrainingSelector(_sets);
  }

  void setExercise(PositionedExercise exercise) {
    _sets.setExercise(exercise);
  }
}
