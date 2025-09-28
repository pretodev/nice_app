import 'package:nice/core/data/entity.dart';
import 'package:nice/features/trainning/data/exercise.dart';
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

  void setExerciseInSet(Exercise exercise, int setIndex, int position) {
    if (setIndex < 0 || setIndex >= sets.length) {
      throw RangeError('Index $setIndex is out of range');
    }
    final set = sets[setIndex];
    if (position < 0 || position >= set.length) {
      throw RangeError('Index $position is out of range');
    }
    final st = sets[setIndex];
    if (st is StraightSet) {
      sets[setIndex] = StraightSet(exercise);
      return;
    }

    if (st is BiSet) {
      if (position == 0) {
        sets[setIndex] = BiSet(exercise, st.second);
        return;
      }
      if (position == 1) {
        sets[setIndex] = BiSet(st.first, exercise);
        return;
      }
    }

    if (st is TriSet) {
      if (position == 0) {
        sets[setIndex] = TriSet(exercise, st.second, st.third);
        return;
      }
      if (position == 1) {
        sets[setIndex] = TriSet(st.first, exercise, st.third);
        return;
      }
      if (position == 2) {
        sets[setIndex] = TriSet(st.first, st.second, exercise);
        return;
      }
    }
  }

  void setExercise(int index, Exercise exercise) {
    if (index < 0 || index >= exercises.length) {
      throw RangeError('Index $index is out of range');
    }
    final targetIndex = exercises.indexWhere((e) => e == exercises[index]);
    var currentIndex = 0;
    var setIndex = 0;
    for (final st in sets) {
      if (st is StraightSet) {
        if (currentIndex == targetIndex) {
          sets[setIndex] = StraightSet(exercise);
          break;
        }
        currentIndex++;
        setIndex++;
        continue;
      }
      if (st is BiSet) {
        if (currentIndex == targetIndex) {
          sets[setIndex] = BiSet(exercise, st.second);
          break;
        }
        if (currentIndex == targetIndex + 1) {
          sets[setIndex] = BiSet(st.first, exercise);
          break;
        }
        currentIndex += 2;
        setIndex++;
        continue;
      }
      if (st is TriSet) {
        if (currentIndex == targetIndex) {
          sets[setIndex] = TriSet(exercise, st.second, st.third);
          break;
        }
        if (currentIndex == targetIndex + 1) {
          sets[setIndex] = TriSet(st.first, exercise, st.third);
          break;
        }
        if (currentIndex == targetIndex + 2) {
          sets[setIndex] = TriSet(st.first, st.second, exercise);
          break;
        }
        currentIndex += 3;
        setIndex++;
      }
    }
  }

  void linkExercises(List<int> indices) {
    if (indices.length < 2) {
      throw ArgumentError('At least 2 indices are required to link exercises');
    }

    for (final index in indices) {
      if (index < 0 || index >= sets.length) {
        throw RangeError('Index $index is out of range');
      }
    }

    if (indices.toSet().length != indices.length) {
      throw ArgumentError('Duplicate indices are not allowed');
    }

    final sortedIndices = List<int>.from(indices)..sort();

    for (final index in sortedIndices) {
      if (sets[index] is TriSet) {
        throw ArgumentError('Cannot link exercises to a TriSet');
      }
    }

    final exercisesToLink = <Exercise>[];
    for (final index in sortedIndices) {
      final set = sets[index];
      if (set is StraightSet) {
        exercisesToLink.add(set.data);
      } else if (set is BiSet) {
        exercisesToLink.addAll([set.first, set.second]);
      }
    }

    ExerciseSet newSet;
    if (exercisesToLink.length == 2) {
      newSet = BiSet(
        exercisesToLink[0],
        exercisesToLink[1],
      );
    } else if (exercisesToLink.length == 3) {
      newSet = TriSet(
        exercisesToLink[0],
        exercisesToLink[1],
        exercisesToLink[2],
      );
    } else {
      throw ArgumentError(
        'Cannot create a set with ${exercisesToLink.length} exercises',
      );
    }

    final newSets = <ExerciseSet>[];
    final firstIndex = sortedIndices.first;

    for (int i = 0; i < firstIndex; i++) {
      if (!sortedIndices.contains(i)) {
        newSets.add(sets[i]);
      }
    }

    newSets.add(newSet);

    for (int i = firstIndex + 1; i < sets.length; i++) {
      if (!sortedIndices.contains(i)) {
        newSets.add(sets[i]);
      }
    }

    sets.clear();
    sets.addAll(newSets);
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

  void reorderSet(int fromIndex, int toIndex) {
    if (fromIndex < 0 ||
        fromIndex >= sets.length ||
        toIndex < 0 ||
        toIndex >= sets.length) {
      throw ArgumentError('Índices inválidos');
    }

    if (fromIndex == toIndex) return;

    final set = sets.removeAt(fromIndex);
    sets.insert(toIndex, set);
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
