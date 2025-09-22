import 'package:nice/trainning/data/exercise.dart';
import 'package:nice/trainning/data/exercise_set.dart';

class EditingTrainning {
  EditingTrainning({
    this.id,
    required this.sets,
  }) : _exercises = [];

  final String? id;
  final List<ExerciseSet> sets;
  final List<Exercise> _exercises;

  void addExercise(Exercise exercise) {
    sets.add(.straightSet(exercise));
    _exercises.add(exercise);
  }


  void removeExercise(Exercise exercise) {
    for (var i = 0; i < sets.length; i++) {
      final item = sets[i];
      if (item is StraightSet && item.data == exercise) {
        sets.remove(item);
        _exercises.remove(exercise);
        break;
      }

      if (item is BiSet) {
        if (item.first == exercise) {
          sets.insert(i, .straightSet(item.second));
          break;
        }
        if (item.second == exercise) {
          sets.insert(i, .straightSet(item.first));
          break;
        }
      }

      if (item is TriSet) {
        if (item.first == exercise) {
          sets.insert(i, .biSet(item.second, item.third));
          break;
        }
        if (item.second == exercise) {
          sets.insert(i, .biSet(item.first, item.third));
          break;
        }
        if (item.third == exercise) {
          sets.insert(i, .biSet(item.first, item.second));
          break;
        }
      }
    }
  }

}
