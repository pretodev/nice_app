import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/core/injector/module.dart';
import 'package:nice/features/aigen/data/open_router.dart';
import 'package:nice/features/app/app_module.dart';
import 'package:nice/features/training/data/firebase/firestore_training_document.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_view_model.dart';
import 'package:nice/shared/environment.dart';

class TrainingModule extends Module {
  @override
  List<Module> get imports => [appModule];

  @override
  void registry(Registry r) {
    r.export.lazySingleton<OpenRouter>(
      (i) => OpenRouter(Environment.openRouterApiKey),
    );
    r.lazySingleton<FirestoreTrainingDocument>(
      (i) => FirestoreTrainingDocument(
        i.get<FirebaseAuth>(),
        i.get<FirebaseFirestore>(),
      ),
    );
    r.lazySingleton<TrainingRepository>(
      (i) => TrainingRepository(
        trainingDocument: i.get<FirestoreTrainingDocument>(),
      ),
    );
    r.export.lazySingleton<TrainingViewModel>(
      (i) =>
          TrainingViewModel(i.get<TrainingRepository>(), i.get<OpenRouter>()),
    );
  }
}
