import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/exercise.dart';
import '../../data/exercise_positioned.dart';
import '../../data/training.dart';
import '../provider_services.dart';

part 'update_exercise_command.g.dart';

@riverpod
class UpdateExercise extends _$UpdateExercise with CommandMixin<Exercise> {
  @override
  AsyncValue<Exercise> build() {
    return invalidState();
  }

  FutureResult<Exercise> call(
    DailyTraining training, {
    required PositionedExercise exercise,
  }) async {
    emitLoading();
    training.setExercise(exercise);
    final result = await ref
        .read(trainingRepositoryProvider)
        .store(training)
        .map((_) => exercise.value);
    return emitResult(result);
  }
}
