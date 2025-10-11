import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/result.dart';
import '../../data/exercise_positioned.dart';
import '../../data/training.dart';
import '../../training_provider.dart';

part 'merge_exercises.g.dart';

@riverpod
class MergeExercises extends _$MergeExercises {
  @override
  AsyncValue<Unit> build() {
    return const AsyncData(unit);
  }

  Future<void> call(
    Training training, {
    required List<PositionedExercise> exercises,
  }) async {
    state = const AsyncLoading();
    training.mergeExercises(exercises);
    final result = await ref.read(trainingRepositoryProvider).store(training);
    state = switch (result) {
      Done() => AsyncData(unit),
      Error() => AsyncError(result.error, StackTrace.current),
    };
  }
}
