import 'package:nice/trainning/data/exercise.dart';
import 'package:nice/trainning/data/exercise_set.dart';

class EditingTrainning {
  EditingTrainning({
    this.id,
    List<ExerciseSet>? sets,
  }) : sets = sets ?? [];

  final String? id;
  final List<ExerciseSet> sets;

  void addExercise(Exercise exercise) {
    sets.add(StraightSet(exercise));
  }

  void linkExercises(List<int> indices) {
    if (indices.length < 2 || indices.length > 3) {
      throw ArgumentError(
        'Deve fornecer 2 ou 3 índices para linkar exercícios',
      );
    }

    indices.sort();
    for (int i = 0; i < indices.length - 1; i++) {
      if (indices[i + 1] - indices[i] != 1) {
        throw ArgumentError('Os índices devem ser consecutivos');
      }
    }

    if (indices.any((index) => index < 0 || index >= sets.length)) {
      throw ArgumentError('Índices inválidos');
    }

    final setsToLink = indices.map((index) => sets[index]).toList();
    if (!setsToLink.every((set) => set is StraightSet)) {
      throw ArgumentError(
        'Só é possível linkar exercícios que sejam StraightSet',
      );
    }

    final exercises = setsToLink
        .cast<StraightSet>()
        .map((set) => set.data)
        .toList();

    for (int i = indices.length - 1; i >= 0; i--) {
      sets.removeAt(indices[i]);
    }

    final ExerciseSet newSet;
    if (exercises.length == 2) {
      newSet = BiSet(exercises[0], exercises[1]);
    } else {
      newSet = TriSet(exercises[0], exercises[1], exercises[2]);
    }

    sets.insert(indices.first, newSet);
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
}
