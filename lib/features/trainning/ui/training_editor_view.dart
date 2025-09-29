import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nice/features/trainning/commands/delete_exercise.dart';
import 'package:nice/features/trainning/data/exercise_positioned.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/training_provider.dart';
import 'package:nice/features/trainning/ui/traning_exercise_editor_view.dart';
import 'package:nice/features/trainning/ui/widgets/exercise_set_widget.dart';
import 'package:nice/features/trainning/ui/widgets/training_editor_bottom_bar.dart';

class TrainingEditorView extends ConsumerStatefulWidget {
  const TrainingEditorView({super.key});

  @override
  ConsumerState<TrainingEditorView> createState() => _TrainingEditorViewState();
}

class _TrainingEditorViewState extends ConsumerState<TrainingEditorView> {
  Training _training = Training(id: 'teste');
  StreamSubscription<Training>? _subscription;

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
    Navigator.push(
      context,
      TraningExerciseEditorView.route(training: _training),
    );
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

    await _deleteExercise(
      _training,
      params: DeleteExerciseParams(
        setIndex: _selected!.setIndex,
        position: _selected!.position,
      ),
    );
  }

  void _editExercise() {
    Navigator.push(
      context,
      TraningExerciseEditorView.route(
        training: _training,
        exercise: _selected,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _subscription = repo.fromId('teste').listen((training) {
      setState(() {
        _training = training;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Editor de treino'),
      ),
      body: _training.sets.isEmpty
          ? const Center(
              child: Text(
                'Sem exercícios',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _training.sets.length,
              itemBuilder: (context, index) {
                final set = _training.sets[index];

                final selectedIndex = _selected?.setIndex == index
                    ? _selected?.position
                    : null;

                final waitingMergeIndex = _mergeSelected.isEmpty
                    ? null
                    : _mergeSelected.first.setIndex == index
                    ? _mergeSelected.first.position
                    : null;

                return ExerciseSetWidget(
                  key: Key('set_$index'),
                  set: set,
                  selectedIndex: selectedIndex,
                  waitingMergeIndex: waitingMergeIndex,
                  onExerciseClicked: (exercise, position) {
                    setState(() {
                      if (index == _selected?.setIndex &&
                          position == _selected?.position) {
                        _selected = null;
                        return;
                      }
                      _selected = PositionedExercise(
                        exercise,
                        setIndex: index,
                        position: position,
                      );
                    });
                  },
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: switch (bottomState) {
        TrainingEditorState.none => FloatingActionButton(
          onPressed: _addExercise,
          tooltip: 'Adicionar exercício',
          child: const Icon(Icons.add),
        ),
        TrainingEditorState.merging => FloatingActionButton(
          onPressed: () {},
          tooltip: 'Mesclar exercícios',
          child: const Icon(Symbols.graph_1_rounded),
        ),
        TrainingEditorState.selecting => FloatingActionButton(
          onPressed: _addExercise,
          tooltip: 'Adicionar exercício',
          child: const Icon(Icons.add),
        ),
      },
      bottomNavigationBar: TrainingEditorBottomBar(
        state: bottomState,
        startMerge: _startMerge,
        editExercise: _editExercise,
        removeExercise: _removeExercise,
        finishMerge: _closeMerge,
      ),
    );
  }
}
