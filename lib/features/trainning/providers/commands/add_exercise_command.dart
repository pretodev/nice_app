import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/providers/provider_services.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_exercise_command.g.dart';

@riverpod
class AddExercise extends _$AddExercise with CommandMixin<Exercise> {
  @override
  AsyncValue<Exercise> build() {
    return invalidState();
  }

  Future<void> call(DailyTraining training, Exercise exercise) async {
    emitLoading();
    final repository = ref.read(trainingRepositoryProvider);
    training.addExercise(exercise);
    final result = await repository.store(training).map((_) => exercise);
    emitResult(result);
  }
}
