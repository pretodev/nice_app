import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nice/core/data/firestore/firestore_custom_reference.dart';
import 'package:nice/core/data/firestore/firestore_extensions.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_execution.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';
import 'package:nice/features/trainning/data/training.dart';

class FirestoreTrainningDocument
    extends FirestoreCustomDocumentReference<Training> {
  FirestoreTrainningDocument() : super('training');

  @override
  Training fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    // TODO: implement fromFirestore
    throw UnimplementedError();
  }

  Map<String, Object?> _executionToFirestore(ExerciseExecution execution) {
    return switch (execution) {
      TimedExerciseExecution() => {
        'type': 'timed',
        'duration': execution.duration.inSeconds,
      },
      SerializedExerciseExecution() => {
        'type': 'serialized',
        'repeats': execution.repeats,
      },
    };
  }

  Map<String, Object?> _exerciseToFirestore(Exercise exercise) {
    return {
      'name': exercise.name,
      'observation': exercise.observation,
      'load': exercise.load,
      'execution': _executionToFirestore(exercise.execution),
    };
  }

  Map<String, Object?> _setToFirestore(ExerciseSet es) {
    return {
      'exercises': es.toList().map(_exerciseToFirestore).toList(),
    };
  }

  @override
  Map<String, Object?> toFirestore(Training value, SetOptions? options) {
    final data = {
      'date': value.date?.toTimestamp(),
      'sets': value.sets.map(_setToFirestore).toList(),
    };
    return data;
  }
}
