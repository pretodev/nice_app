import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nice/trainning/data/editing_trainning.dart';
import 'package:nice/trainning/data/exercise.dart';
import 'package:nice/trainning/data/exercise_execution.dart';

void main() {
  test('EditingTrainning constructor with empty sets', () {
    final trainning = EditingTrainning();
    expect(trainning.sets, []);
  });

  test('EditingTrainning should add a  n exercises', () {
    final randomN = Random().nextInt(100) + 1;
    final exercises = List.generate(
      randomN,
      (index) => Exercise(
        name: 'Ex$index',
        execution: SerializedExerciseExecution([10, 10, 10]),
      ),
    );

    final trainning = EditingTrainning();
    for (final exercise in exercises) {
      trainning.addExercise(exercise);
    }

    expect(trainning.sets.length, exercises.length);
    expect(trainning.totalExercises, exercises.length);
  });

  test('EditingTrainning should add a  biset', () {
    final totalItems = 20;
    final exercises = List.generate(
      totalItems,
      (index) => Exercise(
        name: 'Ex$index',
        execution: SerializedExerciseExecution([10, 10, 10]),
      ),
    );

    final trainning = EditingTrainning();
    for (final exercise in exercises) {
      trainning.addExercise(exercise);
    }

    trainning.linkExercises([0, 1]);
    trainning.linkExercises([4, 7]);
    trainning.linkExercises([10, 11]);
    expect(trainning.sets.length, 17);
  });

  test('EditingTrainning should add a triset', () {
    final totalItems = 20;
    final exercises = List.generate(
      totalItems,
      (index) => Exercise(
        name: 'Ex$index',
        execution: SerializedExerciseExecution([10, 10, 10]),
      ),
    );

    final trainning = EditingTrainning();
    for (final exercise in exercises) {
      trainning.addExercise(exercise);
    }

    trainning.linkExercises([0, 1, 2]);
    trainning.linkExercises([8, 7, 9]);
    expect(trainning.sets.length, 16);
  });

  test('EditingTrainning should add add a biset and a triset', () {
    final totalItems = 20;
    final exercises = List.generate(
      totalItems,
      (index) => Exercise(
        name: 'Ex$index',
        execution: SerializedExerciseExecution([10, 10, 10]),
      ),
    );

    final trainning = EditingTrainning();
    for (final exercise in exercises) {
      trainning.addExercise(exercise);
    }

    trainning.linkExercises([0, 1, 2]);
    trainning.linkExercises([8, 7]);
    expect(trainning.sets.length, 17);
  });

  test('EditingTrainning should add add a biset and a triset', () {
    final totalItems = 20;
    final exercises = List.generate(
      totalItems,
      (index) => Exercise(
        name: 'Ex$index',
        execution: SerializedExerciseExecution([10, 10, 10]),
      ),
    );

    final trainning = EditingTrainning();
    for (final exercise in exercises) {
      trainning.addExercise(exercise);
    }

    trainning.linkExercises([0, 1]);
    expect(trainning.sets.length, 19);
    trainning.linkExercises([0, 7]);
    expect(trainning.sets.length, 18);
  });

  test(
    'EditingTrainning should return error when linking invalid count of exercises',
    () {
      final totalItems = 20;
      final exercises = List.generate(
        totalItems,
        (index) => Exercise(
          name: 'Ex$index',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      );

      final trainning = EditingTrainning();
      for (final exercise in exercises) {
        trainning.addExercise(exercise);
      }
      expect(
        () => trainning.linkExercises([0, 25, 2, 3]),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'EditingTrainning should return error when linking exercises index is out of range',
    () {
      final totalItems = 20;
      final exercises = List.generate(
        totalItems,
        (index) => Exercise(
          name: 'Ex$index',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      );

      final trainning = EditingTrainning();
      for (final exercise in exercises) {
        trainning.addExercise(exercise);
      }
      expect(
        () => trainning.linkExercises([0, 25]),
        throwsA(isA<ArgumentError>()),
      );
    },
  );
}
