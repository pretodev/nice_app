import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/firestore/firestore_trainning_document.dart';
import 'data/training_repository.dart';

part 'training_provider.g.dart';

// data
@riverpod
TrainingRepository trainingRepository(Ref ref) {
  return TrainingRepository(
    trainingDocument: FirestoreTrainningDocument(),
  );
}
