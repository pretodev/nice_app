import 'dart:convert';

import 'package:nice/features/aigen/data/open_router_message.dart';
import 'package:nice/features/aigen/providers/providers.dart';
import 'package:nice/features/exercises/data/exercise.dart';
import 'package:nice/shared/mixins/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_exercises_command.g.dart';

@riverpod
class GetExercises extends _$GetExercises with CommandMixin<List<Exercise>> {
  @override
  AsyncValue<List<Exercise>> build() {
    return invalidState();
  }

  Future<void> call() async {
    emitLoading();

    final openRouter = ref.read(openRouterProvider);
    const systemPrompt =
        'Você é um especialista em educação física. Gere uma lista de exercícios comuns de academia.';
    const userPrompt = '''
Gere uma lista com o máximo possível de exercícios de academia comuns.
Para cada exercício, forneça o nome (em português, nome popular) e uma lista de músculos trabalhados.
Retorne APENAS um JSON válido com a seguinte estrutura:
{
  "exercises": [
    {
      "name": "Nome do Exercício",
      "muscles": ["Músculo 1", "Músculo 2"]
    }
  ]
}
''';

    final result = await openRouter.request(
      model:
          'openai/gpt-3.5-turbo', // Or a cheaper/faster model supported by OpenRouter
      messages: [
        OpenRouterMessage.system(systemPrompt),
        OpenRouterMessage.user(userPrompt),
      ],
      responseFormat: {'type': 'json_object'},
    );

    switch (result) {
      case Ok(value: final jsonString):
        try {
          final Map<String, dynamic> data = jsonDecode(jsonString);
          if (data.containsKey('exercises')) {
            final List<dynamic> list = data['exercises'];
            final exercises = list.map((e) => Exercise.fromJson(e)).toList();
            emitData(exercises);
          } else {
            emitError(
              Exception(
                'Formato de JSON inválido: chave "exercises" não encontrada.',
              ),
            );
          }
        } catch (e, s) {
          emitError(e is Exception ? e : Exception(e), s);
        }
      case Err(value: final error):
        emitError(error);
    }
  }
}
