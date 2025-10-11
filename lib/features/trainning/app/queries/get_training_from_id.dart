import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firestore/firestore_trainning_document.dart';
import '../../data/training.dart';
import '../../data/training_repository.dart';

part 'get_training_from_id.g.dart';

@riverpod
Stream<Training> getTrainingFromId(Ref ref, String id) {
  final repository = TrainingRepository(
    trainingDocument: FirestoreTrainningDocument(),
  );
  return repository.fromId(id);
}
