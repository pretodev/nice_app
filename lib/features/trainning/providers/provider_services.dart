import 'package:nice/features/auth/data/auth_data_provider.dart';
import 'package:nice/features/trainning/data/pocketbase/pocketbase_training_document.dart';
import 'package:nice/features/trainning/data/training_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_services.g.dart';

@riverpod
TrainingRepository trainingRepository(Ref ref) {
  final pb = ref.watch(pocketbaseClientProvider);
  return TrainingRepository(trainingDocument: PocketBaseTrainingDocument(pb));
}
