import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/exercise_positioned.dart';
import '../data/training.dart';
import '../state/commands/delete_exercise.dart';
import '../state/commands/merge_exercises.dart';
import '../state/queries/get_training_from_id.dart';
import 'traning_exercise_editor_view.dart';
import 'widgets/training_editor_body.dart';
import 'widgets/training_editor_bottom_bar.dart';

class TrainingEditorView extends ConsumerStatefulWidget {
  const TrainingEditorView({super.key});

  @override
  ConsumerState<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends ConsumerState<TrainingEditorView> {
  late final _mergeExercises = ref.read(mergeExercisesProvider.notifier);
  late final _deleteExercise = ref.read(deleteExerciseProvider.notifier);

  void _addExercise(Training training) {
    Navigator.push(
      context,
      TraningExerciseEditorView.route(training: training),
    );
  }

  void _removeExercise() async {
    // final delete = await showDialog<bool>(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Remover exercício'),
    //     content: Text(
    //       'Tem certeza que deseja remover o exercício ${_selected?.value.name}?',
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context, false),
    //         child: const Text('Não'),
    //       ),
    //       TextButton(
    //         onPressed: () => Navigator.pop(context, true),
    //         child: const Text('Sim'),
    //       ),
    //     ],
    //   ),
    // );

    // if (!(delete ?? false)) return;

    // await _deleteExercise(
    //   _training,
    //   params: DeleteExerciseParams(
    //     setIndex: _selected!.setIndex,
    //     position: _selected!.position,
    //   ),
    // );
  }

  void _editExercise(Training training, PositionedExercise exercise) {
    Navigator.push(
      context,
      TraningExerciseEditorView.route(
        training: training,
        exercise: exercise,
      ),
    );
  }

  void _selectExercise(Training training, PositionedExercise selected) {
    setState(() {
      if (training.selector.has(selected)) {
        training.selector.remove(selected);
        return;
      }
      training.selector.add(selected);
    });
  }

  PreferredSizeWidget _buildAppBar(AsyncValue<Training> training) {
    if (training is AsyncData && training.requireValue.selector.isNotEmpty) {
      return AppBar(
        backgroundColor: Colors.white,
        title: Text('${training.requireValue.selector.count}'),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            setState(() => training.requireValue.selector.clear());
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
    final training = ref.watch(getTrainingFromIdProvider('teste'));

    ref.listen(mergeExercisesProvider, (prev, next) {
      if (next is AsyncData) {
        setState(() => training.requireValue.selector.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercícios mesclados com sucesso')),
        );
      }
    });

    ref.listen(deleteExerciseProvider, (prev, next) {
      if (next is AsyncData) {
        setState(() => training.requireValue.selector.clear());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${next.value?.name} removido com sucesso')),
        );
      }
    });

    if (training is AsyncLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(training),
      body: TrainingEditorBody(
        value: training,
        onExerciseClicked: (exercise) => training.requireValue.selector.isEmpty
            ? _editExercise(
                training.requireValue,
                exercise,
              )
            : _selectExercise(
                training.requireValue,
                exercise,
              ),
        onExerciseLongPressed: (exercise) => _selectExercise(
          training.requireValue,
          exercise,
        ),
      ),
      floatingActionButton:
          training.hasValue && training.requireValue.selector.isEmpty
          ? FloatingActionButton(
              onPressed: () => _addExercise(training.requireValue),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: .endContained,
      bottomNavigationBar: TrainingEditorBottomBar(
        training: training,
        mergeClicked: () {
          _mergeExercises(
            training.requireValue,
            exercises: training.requireValue.selector.selecteds,
          );
        },
      ),
    );
  }
}
