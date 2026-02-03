import 'package:nice/features/training/data/pocketbase/pocketbase_training_document.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/shared/data/shared_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'training_data_provider.g.dart';

@riverpod
TrainingRepository trainingRepository(Ref ref) {
  final pb = ref.watch(pocketbaseClientProvider);
  return TrainingRepository(trainingDocument: PocketBaseTrainingDocument(pb));
}
