import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nice/app/widgets/field.dart';
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/exercise_execution.dart';
import 'package:nice/features/trainning/ui/widgets/repetition_counter.dart';

import 'widgets/series_counter.dart';

class TraningExerciceEditorView extends StatefulWidget {
  static PageRoute<void> get route {
    return MaterialPageRoute<void>(
      builder: (context) => TraningExerciceEditorView(),
    );
  }

  const TraningExerciceEditorView({super.key});

  @override
  State<TraningExerciceEditorView> createState() =>
      _TraningExerciceEditorViewState();
}

class _TraningExerciceEditorViewState extends State<TraningExerciceEditorView> {
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
    print(exercise);
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
        title: Text('Adicionar exercício'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Field(
              icon: Icon(
                Symbols.edit,
                color: Colors.black26,
              ),
              label: 'Nome do exercício',
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Ex: Abdominal',
                  border: InputBorder.none,
                ),
              ),
            ),
            Field(
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
            Padding(
              padding: const EdgeInsets.symmetric(
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
            Expanded(
              child: ListView.builder(
                itemCount: _expanded ? _execution.countSeries : 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RepetitionCounter(
                      key: Key('repetition_counter_$index'),
                      value: _execution.repeats[index],
                      onChanged: (value) => _setSeriesCount(index, value),
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16.0,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: _submit,
                    child: Text('Adicionar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
