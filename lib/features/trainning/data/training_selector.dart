import 'exercise_positioned.dart';
import 'exercise_set.dart';

class TrainingSelector {
  final List<PositionedExercise> _selecteds;
  final List<ExerciseSet> _sets;

  TrainingSelector(List<ExerciseSet> sets) : _selecteds = [], _sets = sets;

  int get count => _selecteds.length;

  bool get isEmpty => _selecteds.isEmpty;

  bool get isNotEmpty => _selecteds.isNotEmpty;

  List<PositionedExercise> get selecteds => _selecteds;

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

    final selectedSets = <ExerciseSet>[];
    for (final selected in _selecteds) {
      final set = _sets[selected.externalIndex];
      if (!selectedSets.contains(set)) {
        selectedSets.add(set);
      }
    }

    return _canMergeSets(selectedSets);
  }

  bool _canMergeSets(List<ExerciseSet> sets) {
    if (sets.length < 2 || sets.length > 3) return false;

    var totalExercises = 0;
    for (final set in sets) {
      totalExercises += switch (set) {
        StraightSet() => 1,
        BiSet() => 2,
        TriSet() => 3,
      };
    }

    if (totalExercises > 3) return false;

    if (sets.length == 2) {
      final [a, b] = sets;

      if (a is StraightSet && b is StraightSet) return true;

      return ((a is BiSet && b is StraightSet) ||
          (a is StraightSet && b is BiSet));
    }

    if (sets.length == 3) {
      return sets.every((set) => set is StraightSet);
    }

    return false;
  }
}
