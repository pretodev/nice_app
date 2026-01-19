import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/exercises/data/exercise.dart';
import 'package:nice/features/exercises/providers/get_exercises_command.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _filter = _searchController.text;
      });
    });
    // Trigger the command to fetch exercises
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getExercisesProvider.notifier).call();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesState = ref.watch(getExercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gerador de Exercícios')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Filtrar exercícios',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: exercisesState.when(
              data: (exercises) {
                final filteredExercises = exercises
                    .where(
                      (e) => e.name.toLowerCase().contains(
                        _filter.toLowerCase(),
                      ),
                    )
                    .toList();

                if (filteredExercises.isEmpty) {
                  return const Center(
                    child: Text('Nenhum exercício encontrado.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = filteredExercises[index];
                    return ExerciseTile(exercise: exercise);
                  },
                );
              },
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text('Erro ao carregar exercícios: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(getExercisesProvider.notifier).call();
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
              loading: () => ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => const SkeletonTile(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Músculos: ${exercise.muscles.join(", ")}'),
        leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
      ),
    );
  }
}

class SkeletonTile extends StatefulWidget {
  const SkeletonTile({super.key});

  @override
  State<SkeletonTile> createState() => _SkeletonTileState();
}

class _SkeletonTileState extends State<SkeletonTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: _colorAnimation.value),
            title: Container(
              height: 16,
              width: double.infinity,
              color: _colorAnimation.value,
            ),
            subtitle: Container(
              height: 12,
              width: 150,
              margin: const EdgeInsets.only(top: 8),
              color: _colorAnimation.value,
            ),
          ),
        );
      },
    );
  }
}
