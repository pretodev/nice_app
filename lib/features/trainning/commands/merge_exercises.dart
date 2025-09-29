import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/training_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
