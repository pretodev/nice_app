import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/result.dart';
import '../../data/exercise.dart';
import '../../data/exercise_positioned.dart';
import '../../data/training.dart';
import '../provider.dart';

part 'update_exercise.g.dart';

@riverpod
class UpdateExercise extends _$UpdateExercise {
  @override
  AsyncValue<Exercise> build() {
    return AsyncData(.empty());
  }

  Future<void> call(
    Training training, {
    required PositionedExercise exercise,
  }) async {
    final repo = ref.read(trainingRepositoryProvider);
    state = const AsyncLoading();
    training.setExercise(exercise);
    final result = await repo.store(training);
    state = switch (result) {
      Done() => AsyncData(exercise.value),
      Error() => AsyncError(result.error, .current),
    };
  }
}
