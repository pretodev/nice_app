import 'dart:async';

import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/state/command.dart';

class LoadTraining extends Command {
  LoadTraining({
    required TrainingStore trainingStore,
    required TrainingRepository trainingRepository,
  }) : _trainingStore = trainingStore,
       _trainingRepository = trainingRepository;

  final TrainingStore _trainingStore;
  final TrainingRepository _trainingRepository;

  StreamSubscription? _subscription;

  void call(String id) async {
    loading();
    
    // Cancel previous subscription if any
    await _subscription?.cancel();

    _subscription = _trainingRepository.fromId(id).listen(
      (training) {
        _trainingStore.load(training);
        done();
      },
      onError: (error, stackTrace) {
        _trainingStore.error();
        setError(error is Exception ? error : Exception(error));
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
