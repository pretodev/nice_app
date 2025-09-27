import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/training_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_exercise.g.dart';

@riverpod
class AddExercise extends _$AddExercise {
  @override
  AsyncValue<Unit> build() {
    return const AsyncData(unit);
  }

  Future<void> call(Training training, Exercise exercise) async {
    state = const AsyncLoading();
    final repository = ref.read(trainingRepositoryProvider);
    training.addExercise(exercise);
    final result = await repository.store(training);
    switch (result) {
      case Done<Unit>():
        state = const AsyncData(unit);
      case Error<Unit>():
        state = AsyncError(result.error, StackTrace.current);
    }
  }
}
