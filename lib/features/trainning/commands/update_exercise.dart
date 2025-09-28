import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/training_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_exercise.g.dart';

class UpdateExerciseParams {
  const UpdateExerciseParams({
    required this.setIndex,
    required this.position,
    required this.exercise,
  });

  final int setIndex;
  final int position;
  final Exercise exercise;
}

@riverpod
class UpdateExercise extends _$UpdateExercise {
  @override
  AsyncValue<Exercise> build() {
    return AsyncData(Exercise.empty());
  }

  Future<void> call(
    Training training, {
    required UpdateExerciseParams params,
  }) async {
    final repo = ref.read(trainingRepositoryProvider);
    state = const AsyncLoading();
    training.setExerciseInSet(
      params.exercise,
      params.setIndex,
      params.position,
    );
    final result = await repo.store(training);
    state = switch (result) {
      Done() => AsyncData(params.exercise),
      Error() => AsyncError(result.error, StackTrace.current),
    };
  }
}
