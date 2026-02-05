import 'dart:io';

import 'package:nice/features/aigen/data/open_router.dart';
import 'package:nice/features/aigen/data/open_router_message.dart';
import 'package:nice/features/training/data/exercise_set.dart';
import 'package:nice/features/training/data/openRouter/generated_exercise_sets_schema.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/shared/image/file_image_extension.dart';
import 'package:nice/shared/state/command.dart';
import 'package:odu_core/odu_core.dart';

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

class GenerateTraining extends Command {
  GenerateTraining({
    required TrainingStore trainingStore,
    required TrainingRepository trainingRepository,
    required OpenRouter openRouter,
  }) : _trainingStore = trainingStore,
       _trainingRepository = trainingRepository,
       _openRouter = openRouter;

  final TrainingStore _trainingStore;
  final TrainingRepository _trainingRepository;
  final OpenRouter _openRouter;

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

  void call(
    DailyTraining training, {
    required String userMessage,
    File? fileImage,
  }) async {
    loading();

    final result =
        await _getUserMessage(
              userMessage: userMessage,
              fileImage: fileImage,
            )
            .flatMapAsync(
              (message) => _openRouter.request(
                model: 'openai/gpt-5-image-mini',
                messages: [
                  OpenRouterMessage.system(_systemPrompt),
                  message,
                ],
                responseFormat: GeneratedExerciseSetsSchema.schema,
              ),
            )
            .map(GeneratedExerciseSetsSchema.fromJson);

    final exercises = switch (result) {
      Err() => <ExerciseSet>[],
      Ok(value: final sets) => sets,
    };

    if (exercises.isEmpty) {
      if (result is Err) {
        setError((result as Err).value);
      } else {
        done();
      }
      return;
    }

    training.sets.addAll(exercises);
    final storeResult = await _trainingRepository
        .store(training)
        .map((_) => training);

    if (storeResult is Ok) {
      _trainingStore.update(training);
      done();
    } else if (storeResult is Err) {
      setError((storeResult as Err).value);
    }
  }
}
