import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/exercise_positioned.dart';
import '../../data/training.dart';
import '../provider.dart';

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
      Done() => const AsyncData(unit),
      Error() => AsyncError(result.error, .current),
    };
  }
}
