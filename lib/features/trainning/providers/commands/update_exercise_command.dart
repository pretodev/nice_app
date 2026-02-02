import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/providers/provider_services.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_exercise_command.g.dart';

@riverpod
class UpdateExercise extends _$UpdateExercise with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  void call(
    DailyTraining training, {
    required PositionedExercise exercise,
  }) async {
    emitLoading();
    training.setExercise(exercise);
    final result = await ref
        .read(trainingRepositoryProvider)
        .store(training)
        .map((_) => exercise.value);
    emitResult(result);
  }
}
