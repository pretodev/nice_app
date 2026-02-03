import 'package:nice/features/training/data/exercise.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_data_provider.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_exercise_command.g.dart';

@riverpod
class AddExercise extends _$AddExercise with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  void call(DailyTraining training, Exercise exercise) async {
    emitLoading();
    final repository = ref.read(trainingRepositoryProvider);
    training.addExercise(exercise);
    final result = await repository.store(training).map((_) => exercise);

    if (result is Ok) {
      ref.read(trainingStoreProvider.notifier).emit(TrainingUpdated(training));
    }

    emitResult(result);
  }
}
