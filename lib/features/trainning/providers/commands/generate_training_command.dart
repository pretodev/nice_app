import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nice/features/aigen/data/open_router_message.dart';
import 'package:nice/features/aigen/providers/provider_services.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_execution.dart';
import 'package:nice/features/trainning/data/exercise_set.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/shared/image/file_image_extension.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generate_training_command.g.dart';

const _systemPrompt = '''
Você é um especialista em treinamento físico, fisiologia do exercício e prevenção de lesões, com experiência em:
- Musculação
- Treinamento funcional
- Condicionamento físico
- Reabilitação básica e prevenção de lesões
- Prescrição de treino baseada em evidências científicas

Seu objetivo é criar treinos personalizados, seguros e eficazes, sempre alinhados com o desejo do usuário e respeitando suas limitações físicas.

Você não substitui um profissional de saúde. Caso identifique riscos relevantes, deve alertar o usuário claramente.

IMPORTANTE: Você deve retornar um JSON válido seguindo exatamente o schema fornecido.
O JSON deve conter:
- "date": data/hora atual em formato ISO 8601
- "sets": array de conjuntos de exercícios, cada um pode ser:
  - "straight": um único exercício (type, index, exercise)
  - "bi": dois exercícios combinados (type, index, first, second)
  - "tri": três exercícios combinados (type, index, first, second, third)

Cada exercício deve ter:
- "name": nome do exercício
- "execution": pode ser "serialized" (com array "repeats" de inteiros) ou "timed" (com "duration" em milissegundos)
- "observation": string opcional com observações
- "load": número opcional com carga em kg
''';

const _jsonSchema = {
  'type': 'json_schema',
  'json_schema': {
    'name': 'DailyTrainingSchema',
    'strict': true,
    'schema': {
      'type': 'object',
      'properties': {
        'date': {
          'type': 'string',
          'description': 'Data/hora do treino em formato ISO 8601'
        },
        'sets': {
          'type': 'array',
          'description': 'Lista de conjuntos de exercícios',
          'items': {'\$ref': '#/\$defs/ExerciseSet'}
        }
      },
      'required': ['date', 'sets'],
      'additionalProperties': false,
      '\$defs': {
        'ExerciseSet': {
          'type': 'object',
          'properties': {
            'type': {
              'type': 'string',
              'enum': ['straight', 'bi', 'tri'],
              'description':
                  'Tipo do set: straight (1 exercício), bi (2 exercícios), tri (3 exercícios)'
            },
            'index': {
              'type': 'integer',
              'description': 'Índice do set na lista (começando em 0)'
            },
            'exercise': {
              'anyOf': [
                {'\$ref': '#/\$defs/Exercise'},
                {'type': 'null'}
              ]
            },
            'first': {
              'anyOf': [
                {'\$ref': '#/\$defs/Exercise'},
                {'type': 'null'}
              ]
            },
            'second': {
              'anyOf': [
                {'\$ref': '#/\$defs/Exercise'},
                {'type': 'null'}
              ]
            },
            'third': {
              'anyOf': [
                {'\$ref': '#/\$defs/Exercise'},
                {'type': 'null'}
              ]
            }
          },
          'required': ['type', 'index', 'exercise', 'first', 'second', 'third'],
          'additionalProperties': false
        },
        'Exercise': {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string',
              'description': 'Nome do exercício (ex: Supino reto, Agachamento)'
            },
            'execution': {'\$ref': '#/\$defs/ExerciseExecution'},
            'observation': {
              'anyOf': [
                {'type': 'string'},
                {'type': 'null'}
              ]
            },
            'load': {
              'anyOf': [
                {'type': 'number'},
                {'type': 'null'}
              ]
            }
          },
          'required': ['name', 'execution', 'observation', 'load'],
          'additionalProperties': false
        },
        'ExerciseExecution': {
          'type': 'object',
          'properties': {
            'type': {
              'type': 'string',
              'enum': ['serialized', 'timed']
            },
            'repeats': {
              'anyOf': [
                {
                  'type': 'array',
                  'items': {'type': 'integer'}
                },
                {'type': 'null'}
              ]
            },
            'duration': {
              'anyOf': [
                {'type': 'integer'},
                {'type': 'null'}
              ]
            }
          },
          'required': ['type', 'repeats', 'duration'],
          'additionalProperties': false
        }
      }
    }
  }
};

@riverpod
class GenerateTraining extends _$GenerateTraining
    with CommandMixin<DailyTraining> {
  @override
  AsyncValue<DailyTraining> build() {
    return invalidState();
  }

  FutureResult<OpenRouterMessage> _getUserMessage({
    required String userMessage,
    File? fileImage,
  }) async {
    try {
      var userMsg = OpenRouterMessage.user(userMessage);
      if (fileImage != null) {
        userMsg = OpenRouterMessage.userWithImage(
          text: userMessage,
          base64Image: await fileImage.toImageBase64(),
        );
      }
      return Ok(userMsg);
    } on FormatException catch (e) {
      return Err(e);
    }
  }

  Future<void> call({
    required String userMessage,
    File? fileImage,
  }) async {
    emitLoading();

    final openRouter = ref.read(openRouterProvider);

    final result =
        await _getUserMessage(
          userMessage: userMessage,
          fileImage: fileImage,
        ).flatMapAsync(
          (message) => openRouter.request(
            model: 'openai/gpt-5-image-mini',
            messages: [
              OpenRouterMessage.system(_systemPrompt),
              message,
            ],
            responseFormat: _jsonSchema,
          ),
        );

    switch (result) {
      case Ok(value: final content):
        debugPrint('OpenRouter Response: $content');

        final json = jsonDecode(content) as Map<String, dynamic>;
        final training = _createDailyTrainingFromJson(json);

        emitData(training);

      case Err(value: final error):
        debugPrint('OpenRouter Error: $error');
        emitError(
          Exception('Erro ao gerar treino: $error'),
        );
    }
  }

  DailyTraining _createDailyTrainingFromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String;
    final date = DateTime.parse(dateStr);

    final setsJson = json['sets'] as List<dynamic>;
    final sets = setsJson
        .map((s) => _createExerciseSetFromJson(s as Map<String, dynamic>))
        .toList();

    return DailyTraining(
      id: GuidEntity.newId(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
      date: date,
      sets: sets,
    );
  }

  ExerciseSet _createExerciseSetFromJson(Map<String, dynamic> json) {
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

  Exercise _createExerciseFromJson(Map<String, dynamic> json) {
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

  ExerciseExecution _createExecutionFromJson(Map<String, dynamic> json) {
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
}
