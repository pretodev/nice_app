import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odu_core/odu_core.dart';

import 'firestore/firestore_trainning_document.dart';
import 'training.dart';

class TrainingRepository {
  TrainingRepository({required FirestoreTrainningDocument trainingDocument})
    : _trainingDocument = trainingDocument;

  final FirestoreTrainningDocument _trainingDocument;

  Task<Unit> store(Training trainning) async {
    await _trainingDocument
        .ref(trainning.id)
        .set(trainning, SetOptions(merge: true));
    return Result.done;
  }

  Task<Unit> delete(Training trainning) async {
    await _trainingDocument.ref(trainning.id).delete();
    return Result.done;
  }

  Stream<Training> fromId(String id) {
    return _trainingDocument
        .ref(id)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? Training(id: id));
  }
}
