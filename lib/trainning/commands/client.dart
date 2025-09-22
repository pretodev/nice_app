import 'package:nice/trainning/data/editing_trainning.dart';
import 'package:nice/trainning/data/exercise.dart';
import 'package:nice/trainning/data/exercise_execution.dart';

void client() {
  final trainning = EditingTrainning(
    sets: [
      .straightSet(
        Exercise(
          name: 'Barra Livre',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      ),
      .biSet(
        Exercise(
          name: 'Pulldown Cross Barra Grande',
          execution: SerializedExerciseExecution([12, 12, 12]),
        ),
        Exercise(
          name: 'Crucifixo inverso em pé halter',
          execution: SerializedExerciseExecution([12, 12, 12]),
        ),
      ),
      .biSet(
        Exercise(
          name: 'Remada curvada uni',
          execution: SerializedExerciseExecution([12, 12, 12]),
        ),
        Exercise(
          name: 'Remada curvada cross',
          execution: SerializedExerciseExecution([15, 15, 15]),
        ),
      ),
      .straightSet(
        Exercise(
          name: 'Puxador para frente Barra',
          execution: SerializedExerciseExecution([20, 20, 20]),
          observation: 'pouco descanso',
        ),
      ),
      .straightSet(
        Exercise(
          name: 'Puxador para frente Triângulo',
          execution: SerializedExerciseExecution([15, 15, 15]),
        ),
      ),
      .straightSet(
        Exercise(
          name: 'Triceps testa deitado barra',
          execution: SerializedExerciseExecution([12, 12, 12]),
        ),
      ),
      .biSet(
        Exercise(
          name: 'Cross tríceps barra',
          execution: SerializedExerciseExecution([12, 12, 12]),
        ),
        Exercise(
          name: 'Cross tríceps inverso',
          execution: SerializedExerciseExecution([10, 10, 10]),
        ),
      ),
      .straightSet(
        Exercise(
          name: 'Polia baixa tríceps francês corda',
          execution: SerializedExerciseExecution([15, 15, 15]),
        ),
      ),
    ],
  );
}
