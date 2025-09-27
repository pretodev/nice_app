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
    final data = snapshot.data();
    if (data == null) {
      return Training(id: snapshot.id);
    }

    final date = data['date'] as Timestamp?;
    final setsData = data['sets'] as List<dynamic>? ?? [];

    final sets = setsData
        .map((setData) => _setFromFirestore(setData as Map<String, dynamic>))
        .toList();

    return Training(
      id: snapshot.id,
      date: date?.toDate(),
      sets: sets,
    );
  }

  ExerciseSet _setFromFirestore(Map<String, dynamic> data) {
    final exercisesData = data['exercises'] as List<dynamic>;
    final exercises = exercisesData
        .map(
          (exerciseData) =>
              _exerciseFromFirestore(exerciseData as Map<String, dynamic>),
        )
        .toList();

    return switch (exercises.length) {
      1 => StraightSet(exercises[0]),
      2 => BiSet(exercises[0], exercises[1]),
      3 => TriSet(exercises[0], exercises[1], exercises[2]),
      _ => throw ArgumentError(
        'Invalid number of exercises in set: ${exercises.length}',
      ),
    };
  }

  Exercise _exerciseFromFirestore(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final observation = data['observation'] as String?;
    final load = (data['load'] as num?)?.toDouble();
    final executionData = data['execution'] as Map<String, dynamic>;

    return Exercise(
      name: name,
      observation: observation,
      load: load,
      execution: _executionFromFirestore(executionData),
    );
  }

  ExerciseExecution _executionFromFirestore(Map<String, dynamic> data) {
    final type = data['type'] as String;

    return switch (type) {
      'timed' => TimedExerciseExecution(
        Duration(seconds: data['duration'] as int),
      ),
      'serialized' => SerializedExerciseExecution(
        List<int>.from(data['repeats'] as List<dynamic>),
      ),
      _ => throw ArgumentError('Unknown execution type: $type'),
    };
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
