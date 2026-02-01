import 'package:nice/features/auth/providers/provider_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/pocketbase/pocketbase_training_document.dart';
import '../data/training_repository.dart';

part 'provider_services.g.dart';

@riverpod
TrainingRepository trainingRepository(Ref ref) {
  final pb = ref.watch(pocketbaseClientProvider);
  return TrainingRepository(trainingDocument: PocketBaseTrainingDocument(pb));
}
