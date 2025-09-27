import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/firestore/firestore_trainning_document.dart';
import 'package:nice/features/trainning/data/training.dart';

class TrainingRepository {
  TrainingRepository({required FirestoreTrainningDocument trainingDocument})
    : _trainingDocument = trainingDocument;

  final FirestoreTrainningDocument _trainingDocument;

  AsyncResult<Unit> store(Training trainning) async {
    await _trainingDocument
        .ref(trainning.id)
        .set(trainning, SetOptions(merge: true));
    return Result.done;
  }

  AsyncResult<Unit> delete(Training trainning) async {
    await _trainingDocument.ref(trainning.id).delete();
    return Result.done;
  }

  Stream<Training> fromId(String id) {
    return Stream.value(Training());
  }
}
