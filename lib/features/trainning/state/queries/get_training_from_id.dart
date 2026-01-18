import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/training.dart';
import '../provider.dart';

part 'get_training_from_id.g.dart';

@riverpod
Stream<DailyTraining> getTrainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}
