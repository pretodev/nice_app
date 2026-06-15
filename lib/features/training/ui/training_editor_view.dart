import 'package:flutter/material.dart';
import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_status.dart';
import 'package:nice/features/training/state/training_view_model.dart';
import 'package:nice/features/training/ui/training_prompt_modal.dart';
import 'package:nice/features/training/ui/traning_exercise_editor_view.dart';
import 'package:nice/features/training/ui/widgets/training_editor_body.dart';
import 'package:nice/features/training/ui/widgets/training_editor_bottom_bar.dart';
import 'package:nice/shared/state/scope.dart';

class TrainingEditorView extends StatefulWidget {
  const TrainingEditorView({super.key});

  @override
  State<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends State<TrainingEditorView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainingViewModel>().loadTraining('teste');
    });
  }

  void _addExercise(DailyTraining training) {
    Navigator.push(
      context,
      TraningExerciseEditorView.route(training: training),
    );
  }

  void _editExercise(DailyTraining training, PositionedExercise exercise) {
    Navigator.push(
      context,
      TraningExerciseEditorView.route(
        training: training,
        exercise: exercise,
      ),
    );
  }

  void _selectExercise(DailyTraining training, PositionedExercise selected) {
    setState(() {
      if (training.selector.has(selected)) {
        training.selector.remove(selected);
        return;
      }
      training.selector.add(selected);
    });
  }

  PreferredSizeWidget _buildAppBar(DailyTraining? training) {
    if (training != null && training.selector.isNotEmpty) {
      return AppBar(
        backgroundColor: Colors.white,
        title: Text('${training.selector.count}'),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            setState(() => training.selector.clear());
          },
          icon: const Icon(Icons.close),
        ),
      );
    }

    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('Editor de treino'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trainingVm = context.watch<TrainingViewModel>();
    final trainingState = trainingVm.state;

    context.listenCommand(trainingVm.mergeExercises, (command) {
      if (command.isDone && trainingState.training != null) {
        setState(() => trainingState.training!.selector.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercícios mesclados com sucesso')),
        );
      }
    });

    context.listenCommand(trainingVm.generateTraining, (command) {
      if (command.isDone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Treino gerado com sucesso!')),
        );
      } else if (command.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao gerar treino: ${command.failure?.message ?? ''}',
            ),
          ),
        );
      }
    });

    if (trainingState.status == TrainingStatus.loading ||
        trainingState.status == TrainingStatus.idle) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (trainingState.status == TrainingStatus.error) {
      return Scaffold(
        appBar: _buildAppBar(null),
        body: const Center(
          child: Text('Erro ao carregar treino'),
        ),
      );
    }

    final training = trainingState.training!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(training),
      body: TrainingEditorBody(
        state: trainingState,
        onExerciseClicked: (exercise) => training.selector.isEmpty
            ? _editExercise(
                training,
                exercise,
              )
            : _selectExercise(
                training,
                exercise,
              ),
        onExerciseLongPressed: (exercise) => _selectExercise(
          training,
          exercise,
        ),
      ),
      floatingActionButton: training.selector.isEmpty
          ? FloatingActionButton(
              onPressed: () => _addExercise(training),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: TrainingEditorBottomBar(
        state: trainingState,
        mergeClicked: () {
          trainingVm.mergeExercises(training, training.selector.selecteds);
        },
        openPromptEditorClicked: () async {
          await TrainingPromptModal.show(
            context,
            training: training,
          );
        },
      ),
    );
  }
}
