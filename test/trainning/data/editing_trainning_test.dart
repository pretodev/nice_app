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

    test('should create BiSet from two StraightSets', () {
      trainning.linkExercises([0, 1]);

      expect(trainning.sets.length, equals(9));
      expect(trainning.sets.first, isA<BiSet>());
      final biSet = trainning.sets.first as BiSet;
      expect(biSet.first, equals(exercises[0]));
      expect(biSet.second, equals(exercises[1]));
    });

    test('should create TriSet from three StraightSets', () {
      trainning.linkExercises([0, 1, 2]);

      expect(trainning.sets.length, equals(8));
      expect(trainning.sets.first, isA<TriSet>());
      final triSet = trainning.sets.first as TriSet;
      expect(triSet.first, equals(exercises[0]));
      expect(triSet.second, equals(exercises[1]));
      expect(triSet.third, equals(exercises[2]));
    });

    test('should create TriSet from StraightSet and BiSet', () {
      trainning.linkExercises([0, 1]);
      expect(trainning.sets.length, equals(9));

      // Then link the BiSet with another StraightSet (index 1 now refers to what was originally index 2)
      trainning.linkExercises([0, 1]);
      expect(trainning.sets.length, equals(8));
      expect(trainning.sets.first, isA<TriSet>());
      final triSet = trainning.sets.first as TriSet;
      expect(triSet.first, equals(exercises[0]));
      expect(triSet.second, equals(exercises[1]));
      expect(triSet.third, equals(exercises[2]));
    });

    test('should handle non-consecutive indices', () {
      trainning.linkExercises([0, 5, 9]);

      expect(trainning.sets.length, equals(8));
      expect(trainning.sets.first, isA<TriSet>());
      final triSet = trainning.sets.first as TriSet;
      expect(triSet.first, equals(exercises[0]));
      expect(triSet.second, equals(exercises[5]));
      expect(triSet.third, equals(exercises[9]));
    });

    test('should throw error when less than 2 indices provided', () {
      expect(
        () => trainning.linkExercises([0]),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'At least 2 indices are required to link exercises',
          ),
        ),
      );
    });

    test('should throw error when index is out of range', () {
      expect(
        () => trainning.linkExercises([0, 15]),
        throwsA(isA<RangeError>()),
      );

      expect(
        () => trainning.linkExercises([-1, 0]),
        throwsA(isA<RangeError>()),
      );
    });

    test('should throw error when duplicate indices provided', () {
      expect(
        () => trainning.linkExercises([0, 0, 1]),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Duplicate indices are not allowed',
          ),
        ),
      );
    });

    test('should throw error when trying to link to TriSet', () {
      // First create a TriSet
      trainning.linkExercises([0, 1, 2]);

      expect(
        () => trainning.linkExercises([0, 3]),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Cannot link exercises to a TriSet',
          ),
        ),
      );
    });

    test(
      'should throw error when trying to create set with more than 3 exercises',
      () {
        // This scenario shouldn't be possible with current validation, but test the error message
        expect(
          () => trainning.linkExercises([0, 1, 2, 3]),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
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

    test(
      'should convert BiSet to StraightSet when removing first exercise',
      () {
        // Create a BiSet first
        trainning.linkExercises([0, 1]);
        expect(trainning.sets.first, isA<BiSet>());

        trainning.removeExercise(0, 0);

        expect(trainning.sets.first, isA<StraightSet>());
        expect(
          (trainning.sets.first as StraightSet).data,
          equals(exercises[1]),
        );
      },
    );

    test(
      'should convert BiSet to StraightSet when removing second exercise',
      () {
        // Create a BiSet first
        trainning.linkExercises([0, 1]);
        expect(trainning.sets.first, isA<BiSet>());

        trainning.removeExercise(0, 1);

        expect(trainning.sets.first, isA<StraightSet>());
        expect(
          (trainning.sets.first as StraightSet).data,
          equals(exercises[0]),
        );
      },
    );

    test('should convert TriSet to BiSet when removing first exercise', () {
      // Create a TriSet first
      trainning.linkExercises([0, 1, 2]);
      expect(trainning.sets.first, isA<TriSet>());

      trainning.removeExercise(0, 0);

      expect(trainning.sets.first, isA<BiSet>());
      final biSet = trainning.sets.first as BiSet;
      expect(biSet.first, equals(exercises[1]));
      expect(biSet.second, equals(exercises[2]));
    });

    test('should convert TriSet to BiSet when removing middle exercise', () {
      // Create a TriSet first
      trainning.linkExercises([0, 1, 2]);
      expect(trainning.sets.first, isA<TriSet>());

      trainning.removeExercise(0, 1);

      expect(trainning.sets.first, isA<BiSet>());
      final biSet = trainning.sets.first as BiSet;
      expect(biSet.first, equals(exercises[0]));
      expect(biSet.second, equals(exercises[2]));
    });

    test('should convert TriSet to BiSet when removing last exercise', () {
      // Create a TriSet first
      trainning.linkExercises([0, 1, 2]);
      expect(trainning.sets.first, isA<TriSet>());

      trainning.removeExercise(0, 2);

      expect(trainning.sets.first, isA<BiSet>());
      final biSet = trainning.sets.first as BiSet;
      expect(biSet.first, equals(exercises[0]));
      expect(biSet.second, equals(exercises[1]));
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

    test('should throw error when exercise index is invalid for BiSet', () {
      trainning.linkExercises([0, 1]);

      expect(
        () => trainning.removeExercise(0, -1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índice do exercício inválido para BiSet',
          ),
        ),
      );

      expect(
        () => trainning.removeExercise(0, 2),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índice do exercício inválido para BiSet',
          ),
        ),
      );
    });

    test('should throw error when exercise index is invalid for TriSet', () {
      trainning.linkExercises([0, 1, 2]);

      expect(
        () => trainning.removeExercise(0, -1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índice do exercício inválido para TriSet',
          ),
        ),
      );

      expect(
        () => trainning.removeExercise(0, 3),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índice do exercício inválido para TriSet',
          ),
        ),
      );
    });
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

    test('should reorder set from beginning to end', () {
      final firstSet = trainning.sets.first;

      trainning.reorderSet(0, 4);

      expect(trainning.sets.last, equals(firstSet));
      expect((trainning.sets.first as StraightSet).data, equals(exercises[1]));
    });

    test('should reorder set from end to beginning', () {
      final lastSet = trainning.sets.last;

      trainning.reorderSet(4, 0);

      expect(trainning.sets.first, equals(lastSet));
      expect((trainning.sets[1] as StraightSet).data, equals(exercises[0]));
    });

    test('should reorder set in middle', () {
      final secondSet = trainning.sets[1];

      trainning.reorderSet(1, 3);

      expect(trainning.sets[3], equals(secondSet));
      expect((trainning.sets[1] as StraightSet).data, equals(exercises[2]));
    });

    test('should do nothing when fromIndex equals toIndex', () {
      final originalSets = List.from(trainning.sets);

      trainning.reorderSet(2, 2);

      expect(trainning.sets, equals(originalSets));
    });

    test('should throw error when fromIndex is out of range', () {
      expect(
        () => trainning.reorderSet(-1, 0),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índices inválidos',
          ),
        ),
      );

      expect(
        () => trainning.reorderSet(trainning.sets.length, 0),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índices inválidos',
          ),
        ),
      );
    });

    test('should throw error when toIndex is out of range', () {
      expect(
        () => trainning.reorderSet(0, -1),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índices inválidos',
          ),
        ),
      );

      expect(
        () => trainning.reorderSet(0, trainning.sets.length),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Índices inválidos',
          ),
        ),
      );
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

    test('should return two exercises from BiSet', () {
      trainning.linkExercises([0, 1]);

      final result = trainning.getExercisesFromSet(0);

      expect(result.length, equals(2));
      expect(result[0], equals(exercises[0]));
      expect(result[1], equals(exercises[1]));
    });

    test('should return three exercises from TriSet', () {
      trainning.linkExercises([0, 1, 2]);

      final result = trainning.getExercisesFromSet(0);

      expect(result.length, equals(3));
      expect(result[0], equals(exercises[0]));
      expect(result[1], equals(exercises[1]));
      expect(result[2], equals(exercises[2]));
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

    test('should count exercises correctly with mixed set types', () {
      final trainning = Training();
      final exercises = List.generate(
        10,
        (index) => Exercise(
          name: 'Exercise $index',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      );

      for (final exercise in exercises) {
        trainning.addExercise(exercise);
      }

      // Initial: 10 StraightSets = 10 exercises
      expect(trainning.totalExercises, equals(10));

      // Create BiSet: 9 sets total, 10 exercises
      trainning.linkExercises([0, 1]);
      expect(trainning.totalExercises, equals(10));

      // Create TriSet: 8 sets total, 10 exercises
      trainning.linkExercises([0, 2]);
      expect(trainning.totalExercises, equals(10));
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

      // Create some BiSets and TriSets
      trainning.linkExercises([0, 1]); // BiSet
      expect(trainning.sets.length, equals(19));

      trainning.linkExercises([2, 3, 4]); // TriSet
      expect(trainning.sets.length, equals(17));

      trainning.linkExercises([0, 5]); // BiSet + StraightSet = TriSet
      expect(trainning.sets.length, equals(16));

      expect(trainning.totalExercises, equals(20));

      // Remove some exercises
      trainning.removeExercise(0, 0); // TriSet -> BiSet
      expect(trainning.sets.length, equals(16));
      expect(trainning.totalExercises, equals(19));

      // Reorder sets
      trainning.reorderSet(0, 5);
      expect(trainning.sets.length, equals(16));
      expect(trainning.totalExercises, equals(19));

      // Verify we can still get exercises from sets
      final exercisesFromFirstSet = trainning.getExercisesFromSet(0);
      expect(exercisesFromFirstSet.length, greaterThan(0));
    });
  });
}
