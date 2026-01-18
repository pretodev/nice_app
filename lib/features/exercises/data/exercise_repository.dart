import 'package:nice/features/exercises/data/exercise_entity.dart';
import 'package:odu_core/odu_core.dart';

class ExerciseRepository {
  FutureResult<List<ExerciseEntity>> findExercises() async {
    return const Ok([]);
  }
}
