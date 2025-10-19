import 'exercise_positioned.dart';
import 'exercise_set.dart';

class TrainingSelector {
  final List<PositionedExercise> _current;
  final List<PositionedExercise> _selecteds;

  TrainingSelector(List<ExerciseSet> sets)
    : _current = sets.exercises,
      _selecteds = [];

  int get count => _selecteds.length;

  bool get isEmpty => _selecteds.isEmpty;

  bool get isNotEmpty => _selecteds.isNotEmpty;

  void add(PositionedExercise exercise) {
    _selecteds.add(exercise);
  }

  void remove(PositionedExercise exercise) {
    _selecteds.remove(exercise);
  }

  void clear() {
    _selecteds.clear();
  }

  bool has(PositionedExercise exercise) {
    return _selecteds.contains(exercise);
  }

  bool get canMerge {
    if (_selecteds.length < 2) return false;
    if (_selecteds.length > 3) return false;

    for (var i = 0; i < _selecteds.length - 1; i++) {
      final current = _selecteds[i];
      final next = _selecteds[i + 1];

      if (current is TriSet) {
        return false;
      }

      if (current is BiSet && next is BiSet) {
        return false;
      }
    }
    return true;
  }
}
