import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/providers/provider_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_queries.g.dart';

@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}

@riverpod
Stream<DailyTraining> dailyTraining(Ref ref) {
  return ref.read(trainingRepositoryProvider).fromId('teste');
}
