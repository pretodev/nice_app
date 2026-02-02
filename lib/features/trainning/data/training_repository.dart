import 'package:nice/features/trainning/data/pocketbase/pocketbase_training_document.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:odu_core/odu_core.dart';

class TrainingRepository {
  TrainingRepository({required PocketBaseTrainingDocument trainingDocument})
    : _trainingDocument = trainingDocument;

  final PocketBaseTrainingDocument _trainingDocument;

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
