import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/training/data/exercise_positioned.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_status.dart';
import 'package:nice/features/training/state/commands/generate_training_command.dart';
import 'package:nice/features/training/state/commands/load_training_command.dart';
import 'package:nice/features/training/state/commands/merge_exercises_command.dart';
import 'package:nice/features/training/state/training_store.dart';
import 'package:nice/features/training/ui/training_prompt_modal.dart';
import 'package:nice/features/training/ui/traning_exercise_editor_view.dart';
import 'package:nice/features/training/ui/widgets/training_editor_body.dart';
import 'package:nice/features/training/ui/widgets/training_editor_bottom_bar.dart';

class TrainingEditorView extends ConsumerStatefulWidget {
  const TrainingEditorView({super.key});

  @override
  ConsumerState<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends ConsumerState<TrainingEditorView> {
  late final _mergeExercises = ref.read(mergeExercisesProvider.notifier);

  @override
  void initState() {
    super.initState();
    // Inicia o carregamento do treino 'teste' ao iniciar a view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loadTrainingProvider.notifier).call('teste');
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

  AsyncValue<DailyTraining> _mapStateToAsyncValue(TrainingState state) {
    return switch (state.status) {
      TrainingStatus.idle || TrainingStatus.loading => const AsyncLoading(),
      TrainingStatus.error => AsyncError(
        Exception('Error loading training'),
        StackTrace.current,
      ),
      TrainingStatus.loaded when state.training != null => AsyncData(
        state.training!,
      ),
      _ => const AsyncLoading(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final trainingState = ref.watch(trainingStoreProvider);
    final trainingAsync = _mapStateToAsyncValue(trainingState);

    ref.listen(mergeExercisesProvider, (prev, next) {
      if (next is AsyncData && trainingState.training != null) {
        setState(() => trainingState.training!.selector.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercícios mesclados com sucesso')),
        );
      }
    });

    ref.listen(generateTrainingProvider, (prev, next) {
      if (next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Treino gerado com sucesso!')),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar treino: ${next.error}')),
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

    if (trainingAsync.hasError) {
      return Scaffold(
        appBar: _buildAppBar(null),
        body: Center(
          child: Text('Erro ao carregar treino: ${trainingAsync.error}'),
        ),
      );
    }

    final training = trainingAsync.requireValue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(training),
      body: TrainingEditorBody(
        value: trainingAsync,
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
      floatingActionButtonLocation: .endContained,
      bottomNavigationBar: TrainingEditorBottomBar(
        training: trainingAsync,
        mergeClicked: () {
          _mergeExercises(
            training,
            exercises: training.selector.selecteds,
          );
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
