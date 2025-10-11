import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/result.dart';
import '../../data/exercise.dart';
import '../../data/training.dart';
import '../../training_provider.dart';

part 'add_exercise.g.dart';

@riverpod
class AddExercise extends _$AddExercise {
  @override
  AsyncValue<Exercise> build() {
    return AsyncData(Exercise.empty());
  }

  Future<void> call(Training training, Exercise exercise) async {
    state = const AsyncLoading();
    final repository = ref.read(trainingRepositoryProvider);
    training.addExercise(exercise);
    final result = await repository.store(training);
    state = switch (result) {
      Done() => AsyncData(exercise),
      Error() => AsyncError(result.error, StackTrace.current),
    };
  }
}
