import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/exercise.dart';
import '../../data/exercise_positioned.dart';
import '../../data/training.dart';
import '../provider_services.dart';

part 'delete_exercise_command.g.dart';

@riverpod
class DeleteExercise extends _$DeleteExercise with CommandMixin<Exercise> {
  @override
  AsyncValue<Exercise> build() {
    return invalidState();
  }

  Future<void> call(
    DailyTraining training, {
    required PositionedExercise exercise,
  }) async {
    final repo = ref.read(trainingRepositoryProvider);
    state = const AsyncLoading();

    try {
      training.removeExercise(exercise);
      final result = await repo.store(training);
      state = switch (result) {
        Ok() => AsyncData(.empty()),
        Err(value: final err) => AsyncError(err, .current),
      };
    } catch (error) {
      state = AsyncError(error, .current);
    }
  }
}
