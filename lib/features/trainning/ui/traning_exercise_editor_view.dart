import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../shared/widgets/field.dart';
import '../data/exercise.dart';
import '../data/exercise_execution.dart';
import '../data/exercise_positioned.dart';
import '../data/training.dart';
import '../state/commands/add_exercise.dart';
import '../state/commands/update_exercise.dart';
import 'widgets/repetition_counter.dart';
import 'widgets/series_counter.dart';

class TraningExerciseEditorView extends ConsumerStatefulWidget {
  static PageRoute<void> route({
    required DailyTraining training,
    PositionedExercise? exercise,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => TraningExerciseEditorView(
        training: training,
        exercise: exercise,
      ),
    );
  }

  const TraningExerciseEditorView({
    super.key,
    required this.training,
    this.exercise,
  });

  final DailyTraining training;
  final PositionedExercise? exercise;

  @override
  ConsumerState<TraningExerciseEditorView> createState() =>
      _TraningExerciseEditorViewState();
}

class _TraningExerciseEditorViewState
    extends ConsumerState<TraningExerciseEditorView> {
  SerializedExerciseExecution _execution =
      SerializedExerciseExecution.initial();

  bool _expanded = false;

  final _nameController = TextEditingController();

  late final _addExercise = ref.read(addExerciseProvider.notifier);
  late final _updateExercise = ref.read(updateExerciseProvider.notifier);

  void _addSeries() {
    setState(() {
      _execution = _execution.copyWith(
        repeats: [..._execution.repeats, _execution.repeats.last],
      );
    });
  }

  void _removeSeries() {
    if (_execution.countSeries > 1) {
      setState(() {
        _execution = _execution.copyWith(
          repeats: _execution.repeats.sublist(0, _execution.countSeries - 1),
        );
      });
    }
  }

  void _setSeriesCount(int index, int value) {
    if (_execution.isAllEquals && !_expanded) {
      return setState(() {
        _execution = _execution.copyWith(
          repeats: List.filled(_execution.countSeries, value),
        );
      });
    }

    setState(() {
      _execution = _execution.copyWith(
        repeats: [
          ..._execution.repeats.sublist(0, index),
          value,
          ..._execution.repeats.sublist(index + 1),
        ],
      );
    });
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  void _submit() async {
    if (_nameController.text.isEmpty) {
      return;
    }
    final exercise = Exercise(
      name: _nameController.text,
      execution: _execution,
    );
    if (widget.exercise != null) {
      await _updateExercise(
        widget.training,
        exercise: widget.exercise!.copyWith(value: exercise),
      );
    } else {
      await _addExercise(widget.training, exercise);
    }
  }

  @override
  void initState() {
    super.initState();
    _expanded = !_execution.isAllEquals;
    if (widget.exercise != null) {
      final exercise = widget.exercise!.value;
      _nameController.text = exercise.name;
      _execution = exercise.execution as SerializedExerciseExecution;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addExerciseState = ref.watch(addExerciseProvider);
    final updateExerciseState = ref.watch(updateExerciseProvider);

    ref.listen(addExerciseProvider, (previous, next) {
      if (next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercício adicionado com sucesso!'),
          ),
        );
        Navigator.pop(context, next.value);
      }
    });

    ref.listen(updateExerciseProvider, (previous, next) {
      if (next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercício atualizado com sucesso!'),
          ),
        );
        Navigator.pop(context, next.value);
      }
    });

    final isSaving =
        addExerciseState.isLoading || updateExerciseState.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Symbols.close),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Field(
              icon: const Icon(
                Symbols.edit,
                color: Colors.black26,
              ),
              label: 'Nome do exercício',
              child: TextField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Ex: Abdominal',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Field(
              icon: const Icon(
                Symbols.format_list_numbered,
                color: Colors.black26,
              ),
              label: 'Quantidade de series',
              child: SeriesCounter(
                value: _execution.countSeries,
                onIncrementClicked: _addSeries,
                onDecrementClicked: _removeSeries,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const .symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  const Expanded(child: Text('Repetições')),
                  IconButton(
                    icon: Icon(
                      _expanded
                          ? Icons.expand_more_rounded
                          : Icons.expand_less_rounded,
                    ),
                    onPressed: _execution.isAllEquals ? _toggleExpanded : null,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const .only(bottom: 8.0),
                  child: RepetitionCounter(
                    key: Key('repetition_counter_$index'),
                    value: _execution.repeats[index],
                    onChanged: (value) => _setSeriesCount(index, value),
                  ),
                );
              },
              childCount: _expanded ? _execution.countSeries : 1,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !isSaving,
        replacement: const FloatingActionButton(
          onPressed: null,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        child: FloatingActionButton(
          onPressed: _submit,
          child: const Icon(Symbols.check),
        ),
      ),
    );
  }
}
