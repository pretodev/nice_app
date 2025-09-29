import 'package:nice/core/data/entity.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';

class Training extends Entity {
  Training({
    super.id,
    List<ExerciseSet>? sets,
    this.date,
  }) : sets = sets ?? [];

  DateTime? date;

  final List<ExerciseSet> sets;

  void addExercise(Exercise exercise) {
    sets.add(StraightSet(exercise));
  }

  List<Exercise> get exercises {
    return sets.expand((set) => set.toList()).toList();
  }

  void mergeExercises(List<PositionedExercise> positions) {
    if (positions.length < 2) {
      throw ArgumentError('positions must have at least 2 elements');
    }

    if (positions.length > 3) {
      throw ArgumentError('positions cannot have more than 3 elements');
    }

    for (final position in positions) {
      if (position.setIndex < 0 || position.setIndex >= sets.length) {
        throw ArgumentError('Invalid set index: ${position.setIndex}');
      }
    }

    final setIndices = positions.map((p) => p.setIndex).toSet();
    if (setIndices.length != positions.length) {
      throw ArgumentError('Cannot merge exercises from the same set');
    }

    final sortedPositions = List<PositionedExercise>.from(positions)
      ..sort((a, b) => a.setIndex.compareTo(b.setIndex));

    final targetSetIndex = sortedPositions.first.setIndex;

    final exercisesToMerge = sortedPositions
        .map((pos) => (sets[pos.setIndex] as StraightSet).data)
        .toList();

    final ExerciseSet newSet;
    if (exercisesToMerge.length == 2) {
      newSet = BiSet(exercisesToMerge[0], exercisesToMerge[1]);
    } else if (exercisesToMerge.length == 3) {
      newSet = TriSet(
        exercisesToMerge[0],
        exercisesToMerge[1],
        exercisesToMerge[2],
      );
    } else {
      throw ArgumentError('Invalid number of exercises to merge');
    }

    final indicesToRemove = sortedPositions
        .map((pos) => pos.setIndex)
        .toList()
        .reversed
        .toList();

    for (final index in indicesToRemove) {
      sets.removeAt(index);
    }

    sets.insert(targetSetIndex, newSet);
  }

  void setExerciseInSet(PositionedExercise exercise) {
    if (exercise.setIndex < 0 || exercise.setIndex >= sets.length) {
      throw RangeError('Index ${exercise.setIndex} is out of range');
    }
    final set = sets[exercise.setIndex];
    if (exercise.position < 0 || exercise.position >= set.length) {
      throw RangeError('Index ${exercise.position} is out of range');
    }
    final st = sets[exercise.setIndex];
    if (st is StraightSet) {
      sets[exercise.setIndex] = StraightSet(exercise.value);
      return;
    }

    if (st is BiSet) {
      if (exercise.position == 0) {
        sets[exercise.setIndex] = BiSet(exercise.value, st.second);
        return;
      }
      if (exercise.position == 1) {
        sets[exercise.setIndex] = BiSet(st.first, exercise.value);
        return;
      }
    }

    if (st is TriSet) {
      if (exercise.position == 0) {
        sets[exercise.setIndex] = TriSet(exercise.value, st.second, st.third);
        return;
      }
      if (exercise.position == 1) {
        sets[exercise.setIndex] = TriSet(st.first, exercise.value, st.third);
        return;
      }
      if (exercise.position == 2) {
        sets[exercise.setIndex] = TriSet(st.first, st.second, exercise.value);
        return;
      }
    }
  }

  void removeExercise(int setIndex, int exerciseIndex) {
    if (setIndex < 0 || setIndex >= sets.length) {
      throw ArgumentError('Índice do set inválido');
    }

    final set = sets[setIndex];

    if (set is StraightSet) {
      sets.removeAt(setIndex);
    } else if (set is BiSet) {
      if (exerciseIndex < 0 || exerciseIndex > 1) {
        throw ArgumentError('Índice do exercício inválido para BiSet');
      }

      final remainingExercise = exerciseIndex == 0 ? set.second : set.first;
      sets[setIndex] = StraightSet(remainingExercise);
    } else if (set is TriSet) {
      if (exerciseIndex < 0 || exerciseIndex > 2) {
        throw ArgumentError('Índice do exercício inválido para TriSet');
      }

      final exercises = [set.first, set.second, set.third];
      exercises.removeAt(exerciseIndex);
      sets[setIndex] = BiSet(exercises[0], exercises[1]);
    }
  }

  List<Exercise> getExercisesFromSet(int setIndex) {
    if (setIndex < 0 || setIndex >= sets.length) {
      throw ArgumentError('Índice do set inválido');
    }

    final set = sets[setIndex];

    if (set is StraightSet) {
      return [set.data];
    } else if (set is BiSet) {
      return [set.first, set.second];
    } else if (set is TriSet) {
      return [set.first, set.second, set.third];
    }

    return [];
  }

  int get totalExercises {
    return sets.fold(0, (total, set) {
      if (set is StraightSet) return total + 1;
      if (set is BiSet) return total + 2;
      if (set is TriSet) return total + 3;
      return total;
    });
  }

  @override
  String toString() => '''Training(id: $id, date: $date, sets: $sets)''';
}
