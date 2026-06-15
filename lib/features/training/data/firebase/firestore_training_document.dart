import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/features/training/data/exercise.dart';
import 'package:nice/features/training/data/exercise_execution.dart';
import 'package:nice/features/training/data/exercise_set.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/shared/data/firebase/firestore_collection_reference.dart';

class FirestoreTrainingDocument
    extends FirestoreCollectionReference<DailyTraining> {
  FirestoreTrainingDocument(this._auth, FirebaseFirestore firestore)
    : super('daily_trainings', firestore);

  final FirebaseAuth _auth;

  String? get _currentUserId => _auth.currentUser?.uid;

  Exercise _exerciseFromRow(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final observation = data['observation'] as String?;
    final load = (data['load'] as num?)?.toDouble();
    final executionData = data['execution'] as Map<String, dynamic>;

    return Exercise(
      name: name,
      observation: observation,
      load: load,
      execution: _executionFromRow(executionData),
    );
  }

  ExerciseExecution _executionFromRow(Map<String, dynamic> data) {
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

  Map<String, Object?> _executionToRow(ExerciseExecution execution) {
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

  ExerciseSet _setFromRow(int index, Map<String, dynamic> data) {
    final exercisesData = data['exercises'] as List<dynamic>;
    final exercises = exercisesData
        .map(
          (exerciseData) =>
              _exerciseFromRow(exerciseData as Map<String, dynamic>),
        )
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

  DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  @override
  DailyTraining fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final id = snapshot.id;
    final dateRaw = data['date'];
    final setList = data['sets'] as List<dynamic>? ?? [];

    final sets = <ExerciseSet>[];
    for (var i = 0; i < setList.length; i++) {
      sets.add(_setFromRow(i, setList[i] as Map<String, dynamic>));
    }

    return DailyTraining(
      id: id,
      date: dateRaw != null ? _toDateTime(dateRaw) : null,
      sets: sets,
      createdAt: _toDateTime(data['created_at']),
      updatedAt: _toDateTime(data['updated_at']),
      isActive: data['is_active'] as bool? ?? true,
    );
  }

  Map<String, Object?> _exerciseToRow(Exercise exercise) {
    return {
      'name': exercise.name,
      'observation': exercise.observation,
      'load': exercise.load,
      'execution': _executionToRow(exercise.execution),
    };
  }

  Map<String, Object?> _setToRow(ExerciseSet es) {
    return {
      'exercises': switch (es) {
        StraightSet() => [es.data.value],
        BiSet() => [es.first.value, es.second.value],
        TriSet() => [es.first.value, es.second.value, es.third.value],
      }.map(_exerciseToRow).toList(),
    };
  }

  @override
  Map<String, dynamic> toData(DailyTraining entity) {
    final now = DateTime.now();
    return {
      'id': entity.id,
      'user_id': _currentUserId,
      'date': entity.date?.toIso8601String().split('T').first,
      'sets': entity.sets.map(_setToRow).toList(),
      'is_active': entity.isActive,
      'updated_at': Timestamp.fromDate(now),
      'created_at': Timestamp.fromDate(entity.createdAt),
    };
  }

  DailyTraining _createDefaultTraining(String id) {
    return DailyTraining(
      id: id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
      date: DateTime.now(),
    );
  }

  Stream<DailyTraining> streamTrainingById(String id) {
    return streamById(
      id,
    ).map((training) => training ?? _createDefaultTraining(id));
  }
}
