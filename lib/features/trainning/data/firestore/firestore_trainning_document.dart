import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nice/shared/data/firestore/firestore_custom_reference.dart';
import 'package:nice/shared/data/firestore/firestore_extensions.dart';

import '../exercise.dart';
import '../exercise_execution.dart';
import '../exercise_set.dart';
import '../training.dart';

class FirestoreTrainningDocument
    extends FirestoreCustomDocumentReference<DailyTraining> {
  FirestoreTrainningDocument() : super('training');

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

  ExerciseSet _setFromFirestore(int index, Map<String, dynamic> data) {
    final exercisesData = data['exercises'] as List<dynamic>;
    final exercises = exercisesData
        .map((exerciseData) => _exerciseFromFirestore(exerciseData))
        .toList();

    return switch (exercises.length) {
      1 => ExerciseSet.straight(index, exercises[0]),
      2 => ExerciseSet.bi(index, first: exercises[0], second: exercises[1]),
      3 => ExerciseSet.tri(
        index,
        first: exercises[0],
        second: exercises[1],
        third: exercises[2],
      ),
      _ => throw ArgumentError(
        'Invalid number of exercises in set: ${exercises.length}',
      ),
    };
  }

  @override
  DailyTraining fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      return DailyTraining.create(DateTime.now());
    }

    final date = data['date'] as Timestamp?;
    final setList = data['sets'] as List<dynamic>? ?? [];

    final sets = <ExerciseSet>[];
    for (var i = 0; i < setList.length; i++) {
      sets.add(_setFromFirestore(i, setList[i]));
    }

    return DailyTraining(
      id: snapshot.id,
      date: date?.toDate(),
      sets: sets,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] as bool,
    );
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
      'exercises': switch (es) {
        StraightSet() => [es.data.value],
        BiSet() => [es.first.value, es.second.value],
        TriSet() => [es.first.value, es.second.value, es.third.value],
      }.map(_exerciseToFirestore).toList(),
    };
  }

  @override
  Map<String, Object?> toFirestore(DailyTraining value, SetOptions? options) {
    final data = {
      'date': value.date?.toTimestamp(),
      'sets': value.sets.map(_setToFirestore).toList(),
    };
    return data;
  }
}
