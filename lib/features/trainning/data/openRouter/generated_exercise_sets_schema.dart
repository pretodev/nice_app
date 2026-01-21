import 'dart:convert';

import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_execution.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';

abstract final class GeneratedExerciseSetsSchema {
  GeneratedExerciseSetsSchema._();

  static List<ExerciseSet> _parseSetsFromJson(Map<String, dynamic> json) {
    final setsJson = json['sets'] as List<dynamic>;
    final sets = setsJson
        .map((s) => _createExerciseSetFromJson(s as Map<String, dynamic>))
        .toList();

    return sets;
  }

  static ExerciseSet _createExerciseSetFromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final index = json['index'] as int;

    return switch (type) {
      'straight' => ExerciseSet.straight(
        index,
        _createExerciseFromJson(json['exercise'] as Map<String, dynamic>),
      ),
      'bi' => ExerciseSet.bi(
        index,
        first: _createExerciseFromJson(json['first'] as Map<String, dynamic>),
        second: _createExerciseFromJson(json['second'] as Map<String, dynamic>),
      ),
      'tri' => ExerciseSet.tri(
        index,
        first: _createExerciseFromJson(json['first'] as Map<String, dynamic>),
        second: _createExerciseFromJson(json['second'] as Map<String, dynamic>),
        third: _createExerciseFromJson(json['third'] as Map<String, dynamic>),
      ),
      _ => throw Exception('Unknown set type: $type'),
    };
  }

  static Exercise _createExerciseFromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final executionJson = json['execution'] as Map<String, dynamic>;
    final execution = _createExecutionFromJson(executionJson);
    final observation = json['observation'] as String?;
    final load = json['load'] as num?;

    return Exercise(
      name: name,
      execution: execution,
      observation: observation,
      load: load?.toDouble(),
    );
  }

  static ExerciseExecution _createExecutionFromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    return switch (type) {
      'serialized' => SerializedExerciseExecution(
        (json['repeats'] as List<dynamic>).cast<int>(),
      ),
      'timed' => TimedExerciseExecution(
        Duration(milliseconds: json['duration'] as int),
      ),
      _ => throw Exception('Unknown execution type: $type'),
    };
  }

  static List<ExerciseSet> fromJson(String content) {
    final json = jsonDecode(content) as Map<String, dynamic>;
    return _parseSetsFromJson(json);
  }

  static const Map<String, dynamic> schema = {
    'type': 'json_schema',
    'json_schema': {
      'name': 'ExerciseSetsSchema',
      'strict': true,
      'schema': {
        'type': 'object',
        'properties': {
          'sets': {
            'type': 'array',
            'description': 'Lista de conjuntos de exercícios',
            'items': {'\$ref': '#/\$defs/ExerciseSet'},
          },
        },
        'required': ['sets'],
        'additionalProperties': false,
        '\$defs': {
          'ExerciseSet': {
            'type': 'object',
            'properties': {
              'type': {
                'type': 'string',
                'enum': ['straight', 'bi', 'tri'],
                'description':
                    'Tipo do set: straight (1 exercício), bi (2 exercícios), tri (3 exercícios)',
              },
              'index': {
                'type': 'integer',
                'description': 'Índice do set na lista (começando em 0)',
              },
              'exercise': {
                'anyOf': [
                  {'\$ref': '#/\$defs/Exercise'},
                  {'type': 'null'},
                ],
              },
              'first': {
                'anyOf': [
                  {'\$ref': '#/\$defs/Exercise'},
                  {'type': 'null'},
                ],
              },
              'second': {
                'anyOf': [
                  {'\$ref': '#/\$defs/Exercise'},
                  {'type': 'null'},
                ],
              },
              'third': {
                'anyOf': [
                  {'\$ref': '#/\$defs/Exercise'},
                  {'type': 'null'},
                ],
              },
            },
            'required': [
              'type',
              'index',
              'exercise',
              'first',
              'second',
              'third',
            ],
            'additionalProperties': false,
          },
          'Exercise': {
            'type': 'object',
            'properties': {
              'name': {
                'type': 'string',
                'description':
                    'Nome do exercício (ex: Supino reto, Agachamento)',
              },
              'execution': {'\$ref': '#/\$defs/ExerciseExecution'},
              'observation': {
                'anyOf': [
                  {'type': 'string'},
                  {'type': 'null'},
                ],
              },
              'load': {
                'anyOf': [
                  {'type': 'number'},
                  {'type': 'null'},
                ],
              },
            },
            'required': ['name', 'execution', 'observation', 'load'],
            'additionalProperties': false,
          },
          'ExerciseExecution': {
            'type': 'object',
            'properties': {
              'type': {
                'type': 'string',
                'enum': ['serialized', 'timed'],
              },
              'repeats': {
                'anyOf': [
                  {
                    'type': 'array',
                    'items': {'type': 'integer'},
                  },
                  {'type': 'null'},
                ],
              },
              'duration': {
                'anyOf': [
                  {'type': 'integer'},
                  {'type': 'null'},
                ],
              },
            },
            'required': ['type', 'repeats', 'duration'],
            'additionalProperties': false,
          },
        },
      },
    },
  };
}
