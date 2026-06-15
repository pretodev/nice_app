import 'package:auto_injector/auto_injector.dart';
import 'package:nice/features/aigen/data/open_router.dart';
import 'package:nice/features/training/data/firebase/firestore_training_document.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_view_model.dart';
import 'package:nice/shared/environment.dart';

final trainingModule = AutoInjector(
  tag: 'TrainingModule',
  on: (i) {
    i.addLazySingleton(() => OpenRouter(Environment.openRouterApiKey));
    i.addLazySingleton(FirestoreTrainingDocument.new);
    i.addLazySingleton(TrainingRepository.new);
    i.addLazySingleton(TrainingViewModel.new);
  },
);
