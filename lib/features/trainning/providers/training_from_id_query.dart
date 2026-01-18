import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/training.dart';
import 'providers.dart';

part 'training_from_id_query.g.dart';

@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}
