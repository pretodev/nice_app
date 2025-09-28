import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'merge_exercises.g.dart';

class MergeExercisesParams {
  const MergeExercisesParams(this.exercises);

  final List<PositionedExercise> exercises;
}

@riverpod
class MergeExercises extends _$MergeExercises {
  @override
  AsyncValue<Unit> build() {
    return const AsyncData(unit);
  }

  Future<void> call(
    Training training, {
    required MergeExercisesParams params,
  }) async {
    return;
  }
}
