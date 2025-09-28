import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/training_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_exercise.g.dart';

@riverpod
class UpdateExercise extends _$UpdateExercise {
  @override
  AsyncValue<Exercise> build() {
    return AsyncData(Exercise.empty());
  }

  Future<void> call(
    Training training, {
    required PositionedExercise exercise,
  }) async {
    final repo = ref.read(trainingRepositoryProvider);
    state = const AsyncLoading();
    training.setExerciseInSet(exercise);
    final result = await repo.store(training);
    state = switch (result) {
      Done() => AsyncData(exercise.value),
      Error() => AsyncError(result.error, StackTrace.current),
    };
  }
}
