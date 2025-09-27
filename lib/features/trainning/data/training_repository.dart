import 'package:nice/core/data/result.dart';
import 'package:nice/features/trainning/data/training.dart';

class TrainingRepository {
  AsyncResult<Unit> store(Training trainning) async {
    return .done;
  }

  AsyncResult<Unit> delete(Training trainning) async {
    return .done;
  }

  Stream<Training> fromId(String id) {
    return .value(Training());
  }
}
