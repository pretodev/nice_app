import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/firestore/firestore_trainning_document.dart';
import '../data/training_repository.dart';

part 'providers.g.dart';

@riverpod
TrainingRepository trainingRepository(Ref ref) {
  return TrainingRepository(trainingDocument: FirestoreTrainningDocument());
}
