import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

class DeleteExercise extends Command {
  DeleteExercise({
    required this._trainingStore,
    required this._trainingRepository,
  });

  final TrainingStore _trainingStore;
  final TrainingRepository _trainingRepository;

  void call(
    DailyTraining training, {
    required PositionedExercise exercise,
  }) async {
    loading();

    try {
      training.removeExercise(exercise);
      final result = await _trainingRepository.store(training);

      if (result is Ok) {
        _trainingStore.update(training);
        done();
      } else if (result is Err) {
        setError((result as Err).value);
      }
    } catch (error) {
      setError(error is Exception ? error : Exception(error));
    }
  }
}
