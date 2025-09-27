import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nice/app/widgets/field.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_execution.dart';
import 'package:nice/features/trainning/ui/widgets/repetition_counter.dart';

import 'widgets/series_counter.dart';

class TraningExerciceEditorView extends ConsumerStatefulWidget {
  static PageRoute<void> get route {
    return MaterialPageRoute<void>(
      builder: (context) => TraningExerciceEditorView(),
    );
  }

  const TraningExerciceEditorView({super.key});

  @override
  ConsumerState<TraningExerciceEditorView> createState() =>
      _TraningExerciceEditorViewState();
}

class _TraningExerciceEditorViewState
    extends ConsumerState<TraningExerciceEditorView> {
  SerializedExerciseExecution _execution = SerializedExerciseExecution(
    [12, 12, 12],
  );

  bool _expanded = false;

  final _nameController = TextEditingController();

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

  void _submit() {
    if (_nameController.text.isEmpty) {
      return;
    }
    final exercise = Exercise(
      name: _nameController.text,
      execution: _execution,
    );
    Navigator.pop(context, exercise);
  }

  @override
  void initState() {
    super.initState();
    _expanded = !_execution.isAllEquals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Symbols.close),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Field(
              icon: Icon(
                Symbols.edit,
                color: Colors.black26,
              ),
              label: 'Nome do exercício',
              child: TextField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Ex: Abdominal',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Field(
              icon: Icon(
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
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(child: Text('Repetições')),
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
                  padding: EdgeInsets.only(bottom: 8.0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: Icon(Symbols.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
