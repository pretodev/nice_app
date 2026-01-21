import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/training.dart';
import 'provider_services.dart';

part 'provider_queries.g.dart';

@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}

@riverpod
Stream<DailyTraining> dailyTraining(Ref ref) {
  final today = DateTime.now().toIso8601String().split('T')[0];
  return ref.read(trainingRepositoryProvider).fromId('teste');
}
