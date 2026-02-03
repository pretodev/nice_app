import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_data_provider.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'merge_exercises_command.g.dart';

@riverpod
class MergeExercises extends _$MergeExercises with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  void call(
    DailyTraining training, {
    required List<PositionedExercise> exercises,
  }) async {
    emitLoading();
    training.mergeExercises(exercises);
    final result = await ref.read(trainingRepositoryProvider).store(training);

    if (result is Ok) {
      ref.read(trainingStoreProvider.notifier).emit(TrainingUpdated(training));
    }

    emitResult(result);
  }
}
