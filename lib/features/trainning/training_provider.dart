import 'package:nice/features/trainning/data/firestore/firestore_trainning_document.dart';
import 'package:nice/features/trainning/data/training_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'training_provider.g.dart';

// data
@riverpod
TrainingRepository trainingRepository(Ref ref) {
  return TrainingRepository(
    trainingDocument: FirestoreTrainningDocument(),
  );
}
