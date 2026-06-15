import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/core/state/view_model.dart';
import 'package:nice/features/aigen/data/open_router.dart';
import 'package:nice/features/aigen/data/open_router_message.dart';
import 'package:nice/features/training/data/exercise.dart';
import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/exercise_set.dart';
import 'package:nice/features/training/data/openRouter/generated_exercise_sets_schema.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_failures.dart';
import 'package:nice/features/training/data/training_repository.dart';
import 'package:nice/features/training/data/training_status.dart';
import 'package:nice/shared/image/file_image_extension.dart';

const _generateTrainingSystemPrompt = '''
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

typedef GenerateTrainingArgs = ({String message, File? image});

class TrainingViewModel extends ViewModel<TrainingState> {
  TrainingViewModel(this._trainingRepository, this._openRouter)
    : super(const TrainingState());

  final TrainingRepository _trainingRepository;
  final OpenRouter _openRouter;

  StreamSubscription? _trainingSubscription;

  late final addExercise = _addExercise.bind();
  late final deleteExercise = _deleteExercise.bind();
  late final mergeExercises = _mergeExercises.bind();
  late final updateExercise = _updateExercise.bind();
  late final generateTraining = _generateTraining.bind();

  void loadTraining(String id) {
    _trainingSubscription?.cancel();
    emit(state.copyWith(status: TrainingStatus.loading));

    _trainingSubscription = _trainingRepository
        .fromId(id)
        .listen(
          (training) {
            emit(
              state.copyWith(
                training: () => training,
                status: TrainingStatus.loaded,
              ),
            );
          },
          onError: (_, _) {
            emit(state.copyWith(status: TrainingStatus.error));
          },
        );
  }

  FutureResult<Unit> _addExercise(
    DailyTraining training,
    Exercise exercise,
  ) async {
    training.addExercise(exercise);
    final result = await _trainingRepository.store(training);
    if (result.isOk) {
      emit(state.copyWith(training: () => training));
    }
    return result;
  }

  FutureResult<Unit> _deleteExercise(
    DailyTraining training,
    PositionedExercise exercise,
  ) async {
    training.removeExercise(exercise);
    final result = await _trainingRepository.store(training);
    if (result.isOk) {
      emit(state.copyWith(training: () => training));
    }
    return result;
  }

  FutureResult<Unit> _mergeExercises(
    DailyTraining training,
    List<PositionedExercise> exercises,
  ) async {
    training.mergeExercises(exercises);
    final result = await _trainingRepository.store(training);
    if (result.isOk) {
      emit(state.copyWith(training: () => training));
    }
    return result;
  }

  FutureResult<Unit> _updateExercise(
    DailyTraining training,
    PositionedExercise exercise,
  ) async {
    training.setExercise(exercise);
    final result = await _trainingRepository.store(training);
    if (result.isOk) {
      emit(state.copyWith(training: () => training));
    }
    return result;
  }

  FutureResult<Unit> _generateTraining(
    DailyTraining training,
    GenerateTrainingArgs args,
  ) async {
    final result = await _buildUserMessage(args)
        .flatMapAsync(
          (message) => _openRouter.request(
            model: 'openai/gpt-5-image-mini',
            messages: [
              OpenRouterMessage.system(_generateTrainingSystemPrompt),
              message,
            ],
            responseFormat: GeneratedExerciseSetsSchema.schema,
          ),
        )
        .map(GeneratedExerciseSetsSchema.fromJson);

    if (result case Err(:final failure)) return Err(failure);
    final exercises = (result as Ok<List<ExerciseSet>>).value;
    if (exercises.isEmpty) return ok;

    training.sets.addAll(exercises);
    final storeResult = await _trainingRepository.store(training);
    if (storeResult.isOk) {
      emit(state.copyWith(training: () => training));
    }
    return storeResult;
  }

  FutureResult<OpenRouterMessage> _buildUserMessage(
    GenerateTrainingArgs args,
  ) async {
    try {
      if (args.image == null) {
        return Ok(OpenRouterMessage.user(args.message));
      }
      return Ok(
        OpenRouterMessage.userWithImage(
          text: args.message,
          base64Image: await args.image!.toImageBase64(),
        ),
      );
    } on FormatException catch (e) {
      return Err(TrainingGenerationFailure(e.message));
    }
  }

  @override
  void dispose() {
    _trainingSubscription?.cancel();
    super.dispose();
  }
}

@immutable
final class TrainingState extends Equatable {
  final DailyTraining? training;
  final TrainingStatus status;

  const TrainingState({
    this.training,
    this.status = TrainingStatus.idle,
  });

  TrainingState copyWith({
    ValueGetter<DailyTraining?>? training,
    TrainingStatus? status,
  }) {
    return TrainingState(
      training: training != null ? training() : this.training,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [training, status];

  @override
  bool get stringify => true;
}
