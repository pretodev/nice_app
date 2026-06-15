import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/training/data/exercise.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/state/command.dart';

class AddExercise extends Command {
  AddExercise({
    required this._trainingStore,
    required this._trainingRepository,
  });

  final TrainingStore _trainingStore;
  final TrainingRepository _trainingRepository;

  void call(DailyTraining training, Exercise exercise) async {
    loading();
    training.addExercise(exercise);
    final result = await _trainingRepository
        .store(training)
        .map((_) => exercise);

    if (result case Err(:final failure)) {
      return setError(failure);
    }

    _trainingStore.update(training);
    done();
  }
}
