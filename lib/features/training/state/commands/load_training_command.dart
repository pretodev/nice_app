import 'dart:async';

import 'package:nice/features/training/data/training_data_provider.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_training_command.g.dart';

@Riverpod(keepAlive: true)
class LoadTraining extends _$LoadTraining with CommandMixin {
  @override
  AsyncValue<Unit> build() => invalidState();

  StreamSubscription? _subscription;

  void call(String id) async {
    emitLoading();
    ref.onDispose(() => _subscription?.cancel());

    final repo = ref.read(trainingRepositoryProvider);
    final store = ref.read(trainingStoreProvider.notifier);

    // Cancel previous subscription if any
    await _subscription?.cancel();

    _subscription = repo
        .fromId(id)
        .listen(
          (training) {
            store.emit(TrainingLoaded(training));
            emitOk();
          },
          onError: (error, stackTrace) {
            store.emit(const TrainingError());
            emitError(error, stackTrace);
          },
        );
  }
}
