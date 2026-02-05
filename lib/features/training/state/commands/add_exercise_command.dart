import 'package:nice/features/training/data/exercise.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

class AddExercise extends Command {
  AddExercise({
    required TrainingStore trainingStore,
    required TrainingRepository trainingRepository,
  }) : _trainingStore = trainingStore,
       _trainingRepository = trainingRepository;

  final TrainingStore _trainingStore;
  final TrainingRepository _trainingRepository;

  void call(DailyTraining training, Exercise exercise) async {
    loading();
    training.addExercise(exercise);
    final result = await _trainingRepository
        .store(training)
        .map((_) => exercise);

    if (result case Err(:final value)) {
      return setError(value);
    }

    _trainingStore.update(training);
    done();
  }
}
