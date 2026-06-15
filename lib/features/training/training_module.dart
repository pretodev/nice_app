import 'package:auto_injector/auto_injector.dart';
import 'package:nice/features/aigen/data/open_router.dart';
import 'package:nice/features/training/data/firebase/firestore_training_document.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/commands/add_exercise_command.dart';
import 'package:nice/features/training/state/commands/delete_exercise_command.dart';
import 'package:nice/features/training/state/commands/generate_training_command.dart';
import 'package:nice/features/training/state/commands/load_training_command.dart';
import 'package:nice/features/training/state/commands/merge_exercises_command.dart';
import 'package:nice/features/training/state/commands/update_exercise_command.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/environment.dart';
import 'package:nice/shared/state/command.dart';

final trainingModule = AutoInjector(
  tag: 'TrainingModule',
  on: (i) {
    // Services
    i.addLazySingleton(() => OpenRouter(Environment.openRouterApiKey));
    i.addLazySingleton(FirestoreTrainingDocument.new);
    i.addLazySingleton(TrainingRepository.new);

    // State
    i.addLazySingleton(TrainingStore.new);

    // Commands
    i.addLazySingleton(LoadTraining.new, config: commandConfig);
    i.addLazySingleton(AddExercise.new, config: commandConfig);
    i.addLazySingleton(DeleteExercise.new, config: commandConfig);
    i.addLazySingleton(MergeExercises.new, config: commandConfig);
    i.addLazySingleton(UpdateExercise.new, config: commandConfig);
    i.addLazySingleton(GenerateTraining.new, config: commandConfig);
  },
);
