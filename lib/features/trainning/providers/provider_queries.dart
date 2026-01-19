import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/training.dart';
import 'provider_services.dart';

part 'provider_queries.g.dart';

@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}
