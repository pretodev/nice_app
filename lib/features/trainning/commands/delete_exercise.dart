import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/training_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_exercise.g.dart';

class DeleteExerciseParams {
  const DeleteExerciseParams({
    required this.setIndex,
    required this.position,
  });

  final int setIndex;
  final int position;
}

@riverpod
class DeleteExercise extends _$DeleteExercise {
  @override
  AsyncValue<Exercise> build() {
    return AsyncData(Exercise.empty());
  }

  Future<void> call(
    Training training, {
    required DeleteExerciseParams params,
  }) async {
    final repo = ref.read(trainingRepositoryProvider);
    state = const AsyncLoading();
    
    try {
      training.removeExercise(params.setIndex, params.position);
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