import 'package:nice/shared/data/pocketbase/pocketbase_table_reference.dart';
import 'package:pocketbase/pocketbase.dart';

import '../exercise.dart';
import '../exercise_execution.dart';
import '../exercise_set.dart';
import '../training.dart';

class PocketBaseTrainingDocument
    extends PocketBaseTableReference<DailyTraining> {
  PocketBaseTrainingDocument(PocketBase pb) : super('daily_trainings', pb);

  String? get _currentUserId => pb.authStore.record?.id;

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

  @override
  DailyTraining fromRecord(RecordModel record) {
    final id = record.id;
    final dateStr = record.data['date'] as String?;
    final setList = record.data['sets'] as List<dynamic>? ?? [];

    final sets = <ExerciseSet>[];
    for (var i = 0; i < setList.length; i++) {
      sets.add(_setFromRow(i, setList[i] as Map<String, dynamic>));
    }

    final createdStr = record.get<String>('created');
    final updatedStr = record.get<String>('updated');

    return DailyTraining(
      id: id,
      date: dateStr != null ? DateTime.parse(dateStr) : null,
      sets: sets,
      createdAt: createdStr.isNotEmpty
          ? DateTime.parse(createdStr)
          : DateTime.now(),
      updatedAt: updatedStr.isNotEmpty
          ? DateTime.parse(updatedStr)
          : DateTime.now(),
      isActive: record.data['is_active'] as bool? ?? true,
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
    return {
      'id': entity.id,
      'user_id': _currentUserId,
      'date': entity.date?.toIso8601String().split('T').first,
      'sets': entity.sets.map(_setToRow).toList(),
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
