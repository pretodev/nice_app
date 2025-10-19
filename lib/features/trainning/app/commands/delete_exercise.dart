import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/result.dart';
import '../../data/exercise.dart';
import '../../data/exercise_positioned.dart';
import '../../data/training.dart';
import '../provider.dart';

part 'delete_exercise.g.dart';

@riverpod
class DeleteExercise extends _$DeleteExercise {
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

    try {
      training.removeExercise(exercise);
      final result = await repo.store(training);
      state = switch (result) {
        Done() => AsyncData(Exercise.empty()),
        Error() => AsyncError(result.error, StackTrace.current),
      };
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
