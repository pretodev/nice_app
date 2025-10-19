import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/commands/delete_exercise.dart';
import '../app/provider.dart';
import '../app/queries/get_training_from_id.dart';
import '../data/exercise_positioned.dart';
import '../data/training.dart';
import 'models/training_editor_state.dart';
import 'traning_exercise_editor_view.dart';
import 'widgets/training_editor_body.dart';
import 'widgets/training_editor_bottom_bar.dart';

class TrainingEditorView extends ConsumerStatefulWidget {
  const TrainingEditorView({super.key});

  @override
  ConsumerState<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends ConsumerState<TrainingEditorView> {
  late final repo = ref.read(trainingRepositoryProvider);
  late final _deleteExercise = ref.read(deleteExerciseProvider.notifier);

  PositionedExercise? _selected;

  List<PositionedExercise> _mergeSelected = [];

  void _startMerge() {
    if (_selected == null) return;
    setState(() {
      _mergeSelected = [_selected!];
    });
  }

  void _closeMerge() {
    setState(() => _mergeSelected = []);
  }

  void _addExercise() {
    // Navigator.push(
    //   context,
    //   TraningExerciseEditorView.route(training: _training),
    // );
  }

  void _removeExercise() async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover exercício'),
        content: Text(
          'Tem certeza que deseja remover o exercício ${_selected?.value.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (!(delete ?? false)) return;

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

  @override
  Widget build(BuildContext context) {
    var bottomState = TrainingEditorState.none;
    if (_selected != null) {
      bottomState = TrainingEditorState.selecting;
    }
    if (_mergeSelected.isNotEmpty) {
      bottomState = TrainingEditorState.merging;
    }

    ref.listen(deleteExerciseProvider, (prev, next) {
      if (next is AsyncData) {
        setState(() => _selected = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${next.value?.name} removido com sucesso')),
        );
      }
    });

    final training = ref.watch(getTrainingFromIdProvider('teste'));

    if (training is AsyncLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Editor de treino'),
      ),
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

      bottomNavigationBar: TrainingEditorBottomBar(
        state: bottomState,
        addExercise: () {},
        removeExercise: _removeExercise,
        startMerge: _startMerge,
        finishMerge: _closeMerge,
      ),
    );
  }
}
