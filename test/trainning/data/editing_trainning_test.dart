import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_execution.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';
import 'package:nice/features/trainning/data/training.dart';

void main() {
  group('EditingTrainning Constructor', () {
    test('should create with empty sets when no sets provided', () {
      final trainning = Training();
      expect(trainning.sets, isEmpty);
      expect(trainning.id, isNull);
    });

    test('should create with provided id and sets', () {
      final exercise = Exercise(
        name: 'Test Exercise',
        execution: SerializedExerciseExecution([10, 10, 10]),
      );
      final sets = [StraightSet(exercise)];

      final trainning = Training(id: 'test-id', sets: sets);
      expect(trainning.id, equals('test-id'));
      expect(trainning.sets, equals(sets));
    });
  });

  group('addExercise', () {
    test('should add single exercise as StraightSet', () {
      final trainning = Training();
      final exercise = Exercise(
        name: 'Test Exercise',
        execution: SerializedExerciseExecution([10, 10, 10]),
      );

      trainning.addExercise(exercise);

      expect(trainning.sets.length, equals(1));
      expect(trainning.sets.first, isA<StraightSet>());
      expect((trainning.sets.first as StraightSet).data, equals(exercise));
    });

    test('should add multiple exercises as separate StraightSets', () {
      final trainning = Training();
      final exercises = List.generate(
        5,
        (index) => Exercise(
          name: 'Exercise $index',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      );

      for (final exercise in exercises) {
        trainning.addExercise(exercise);
      }

      expect(trainning.sets.length, equals(5));
      expect(trainning.totalExercises, equals(5));
      for (int i = 0; i < exercises.length; i++) {
        expect(trainning.sets[i], isA<StraightSet>());
        expect((trainning.sets[i] as StraightSet).data, equals(exercises[i]));
      }
    });
  });

  group('linkExercises', () {
    late Training trainning;
    late List<Exercise> exercises;

    setUp(() {
      trainning = Training();
      exercises = List.generate(
        10,
        (index) => Exercise(
          name: 'Exercise $index',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      );
      for (final exercise in exercises) {
        trainning.addExercise(exercise);
      }
    });
  });

  group('removeExercise', () {
    late Training trainning;
    late List<Exercise> exercises;

    setUp(() {
      trainning = Training();
      exercises = List.generate(
        6,
        (index) => Exercise(
          name: 'Exercise $index',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      );
      for (final exercise in exercises) {
        trainning.addExercise(exercise);
      }
    });

    test('should remove entire StraightSet', () {
      final initialLength = trainning.sets.length;

      trainning.removeExercise(0, 0);

      expect(trainning.sets.length, equals(initialLength - 1));
      expect((trainning.sets.first as StraightSet).data, equals(exercises[1]));
    });

    test('should throw error when set index is out of range', () {
      expect(
        () => trainning.removeExercise(-1, 0),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índice do set inválido',
          ),
        ),
      );

      expect(
        () => trainning.removeExercise(trainning.sets.length, 0),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índice do set inválido',
          ),
        ),
      );
    });

    group('reorderSet', () {
      late Training trainning;
      late List<Exercise> exercises;

      setUp(() {
        trainning = Training();
        exercises = List.generate(
          5,
          (index) => Exercise(
            name: 'Exercise $index',
            execution: SerializedExerciseExecution([10, 10, 10]),
          ),
        );
        for (final exercise in exercises) {
          trainning.addExercise(exercise);
        }
      });
    });

    group('getExercisesFromSet', () {
      late Training trainning;
      late List<Exercise> exercises;

      setUp(() {
        trainning = Training();
        exercises = List.generate(
          6,
          (index) => Exercise(
            name: 'Exercise $index',
            execution: SerializedExerciseExecution([10, 10, 10]),
          ),
        );
        for (final exercise in exercises) {
          trainning.addExercise(exercise);
        }
      });

      test('should return single exercise from StraightSet', () {
        final result = trainning.getExercisesFromSet(0);

        expect(result.length, equals(1));
        expect(result.first, equals(exercises[0]));
      });

      test('should throw error when set index is out of range', () {
        expect(
          () => trainning.getExercisesFromSet(-1),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Índice do set inválido',
            ),
          ),
        );

        expect(
          () => trainning.getExercisesFromSet(trainning.sets.length),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Índice do set inválido',
            ),
          ),
        );
      });

      test('should throw error when set index is out of range', () {
        expect(
          () => trainning.getExercisesFromSet(-1),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Índice do set inválido',
            ),
          ),
        );

        expect(
          () => trainning.getExercisesFromSet(trainning.sets.length),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Índice do set inválido',
            ),
          ),
        );
      });
    });

    group('totalExercises', () {
      test('should return 0 for empty training', () {
        final trainning = Training();
        expect(trainning.totalExercises, equals(0));
      });

      test('should handle random number of exercises', () {
        final trainning = Training();
        final randomN = Random().nextInt(50) + 1;
        final exercises = List.generate(
          randomN,
          (index) => Exercise(
            name: 'Exercise $index',
            execution: SerializedExerciseExecution([10, 10, 10]),
          ),
        );

        for (final exercise in exercises) {
          trainning.addExercise(exercise);
        }

        expect(trainning.totalExercises, equals(randomN));
      });
    });

    group('Integration Tests', () {
      test('should handle complex sequence of operations', () {
        final trainning = Training();
        final exercises = List.generate(
          20,
          (index) => Exercise(
            name: 'Exercise $index',
            execution: SerializedExerciseExecution([10, 10, 10]),
          ),
        );

        // Add all exercises
        for (final exercise in exercises) {
          trainning.addExercise(exercise);
        }
        expect(trainning.sets.length, equals(20));
        expect(trainning.totalExercises, equals(20));

        // Remove some exercises
        trainning.removeExercise(0, 0); // TriSet -> BiSet
        expect(trainning.sets.length, equals(16));
        expect(trainning.totalExercises, equals(19));

        // Verify we can still get exercises from sets
        final exercisesFromFirstSet = trainning.getExercisesFromSet(0);
        expect(exercisesFromFirstSet.length, greaterThan(0));
      });
    });
  });
}
