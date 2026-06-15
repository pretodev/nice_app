import 'package:nice/features/training/data/firebase/firestore_training_document.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:odu_core/odu_core.dart';

class TrainingRepository {
  TrainingRepository({required this._trainingDocument});

  final FirestoreTrainingDocument _trainingDocument;

  FutureResult<Unit> store(DailyTraining trainning) async {
    await _trainingDocument.upsert(trainning);
    return ok;
  }

  FutureResult<Unit> delete(DailyTraining trainning) async {
    await _trainingDocument.delete(trainning.id);
    return ok;
  }

  Stream<DailyTraining> fromId(String id) {
    return _trainingDocument.streamTrainingById(id);
  }
}
