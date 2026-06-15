import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

class MergeExercises extends Command {
  MergeExercises({
    required this._trainingStore,
    required this._trainingRepository,
  });

  final TrainingStore _trainingStore;
  final TrainingRepository _trainingRepository;

  void call(
    DailyTraining training, {
    required List<PositionedExercise> exercises,
  }) async {
    loading();
    training.mergeExercises(exercises);
    final result = await _trainingRepository.store(training);

    if (result is Ok) {
      _trainingStore.update(training);
      done();
    } else if (result is Err) {
      setError((result as Err).value);
    }
  }
}
