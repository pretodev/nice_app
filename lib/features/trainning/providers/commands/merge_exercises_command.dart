import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/providers/provider_services.dart';
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
    state = const AsyncLoading();
    training.mergeExercises(exercises);
    final result = await ref.read(trainingRepositoryProvider).store(training);
    state = switch (result) {
      Ok() => const AsyncData(unit),
      Err(value: final err) => AsyncError(err, .current),
    };
  }
}
