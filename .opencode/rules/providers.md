# Provider Guidelines

Guidelines for creating Riverpod providers in Flutter applications. These rules apply to both AI assistants and developers.

## Overview

Providers are components that handle dependency injection and global application state management, providing the data layer elements or commands (use cases). They are categorized into three types based on their purpose:

| Type       | Purpose                                       | Naming Pattern           | Example                        |
| ---------- | --------------------------------------------- | ------------------------ | ------------------------------ |
| Service    | Dependency injection for services             | `*Provider`              | `trainingRepositoryProvider`   |
| Query      | Pre-customized data sources for UI            | `*Query` or `*Provider`  | `trainingFromIdProvider`       |
| Command    | Use cases with loading/success/error states   | `*Command` or class name | `addExerciseProvider`          |

## Location

Providers are located in specific directories based on their scope:

- **Feature providers**: `lib/features/<feature>/providers/`
- **Shared service providers**: `lib/shared/provider.dart` (only service providers, never commands or queries)

## Code Generation

This project uses `riverpod_annotation` for provider generation. Always include:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'your_file.g.dart';
```

Run code generation after creating or modifying providers:
```bash
dart run build_runner build -d
```

**Note**: The `-d` flag is short for `--delete-conflicting-outputs`.

## Service Providers

Service providers handle dependency injection for repositories, clients, and other services.

### Location

- **Feature-specific services**: `lib/features/<feature>/providers/providers.dart`
- **Shared services**: `lib/shared/provider.dart` (only service providers, never commands or queries)

### Structure

```dart
// lib/features/trainning/providers/providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/firestore/firestore_trainning_document.dart';
import '../data/training_repository.dart';

part 'providers.g.dart';

@riverpod
TrainingRepository trainingRepository(Ref ref) {
  return TrainingRepository(
    trainingDocument: FirestoreTrainningDocument(),
  );
}
```

### Best Practices

- Place feature service providers in a `providers.dart` file within the feature
- Place shared service providers in `lib/shared/provider.dart`
- Keep service providers simple and focused on wiring dependencies
- Use `ref.read()` to access other providers
- Avoid business logic in service providers
- The `providers.dart` file provides all data elements of a feature/module

## Query Providers

Query providers are pre-customized data sources that abstract access to certain data, making it ready to be consumed by the UI. They fetch data and provide reactive streams or async values.

### Structure

```dart
// lib/features/trainning/providers/training_from_id_query.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/training.dart';
import 'providers.dart';

part 'training_from_id_query.g.dart';

@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}
```

### Naming Conventions

- Name query files with `*_query.dart` suffix for clarity
- Function name should describe what data is being fetched
- Use descriptive parameter names

### Best Practices

- Return `Stream<T>` for real-time data subscriptions
- Return `Future<T>` for one-time fetches
- Use `ref.read()` to access repositories
- Keep queries simple - just fetch and return data
- Do not include business logic in queries
- Queries abstract data access, making it ready for UI consumption

## Command Providers

Command providers are Dart use cases that handle mutations, side effects, and complex operations that modify state. They serve to connect business rules with the infrastructure, being able to access services, verify rules, emit events, etc. Commands are reactive elements because they can have triple states: loading, success, and error.

### Location

When a command is needed, create a separate file for it:
- `lib/features/<feature>/providers/<action>_command.dart`
- Example: the command `registerUser` will be in `providers/register_user_command.dart`

### CommandMixin

All commands must use the `CommandMixin<T>` mixin from `lib/shared/providers/command_provider_base_mixin.dart`. This mixin provides:

- **`invalidState()`**: Returns an error state for initial build (command not yet called)
- **`setLoading()`**: Sets loading state with `ref.mounted` check
- **`setData(T data)`**: Sets success state and returns `Ok(data)`
- **`setError<E>(E error, [StackTrace?])`**: Sets error state and returns `Err(error)`

```dart
// lib/shared/providers/command_provider_base_mixin.dart
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

AsyncValue<T> invalidState<T>() => AsyncError<T>(
  StateError('Not called yet'),
  StackTrace.current,
);

mixin CommandMixin<T> on $Notifier<AsyncValue<T>> {
  Result<T> setError<E extends Exception>(E error, [StackTrace? stackTrace]) {
    if (ref.mounted) {
      state = AsyncError(error, stackTrace ?? StackTrace.current);
    }
    return Err(error, stackTrace);
  }

  Result<T> setData(T data) {
    if (ref.mounted) {
      state = AsyncData(data);
    }
    return Ok(data);
  }

  void setLoading() {
    if (ref.mounted) {
      state = const AsyncLoading();
    }
  }
}
```

### Structure

Commands are implemented as notifier classes with `CommandMixin` and a `call()` method:

```dart
// lib/features/trainning/providers/add_exercise_command.dart
import 'package:nice/features/trainning/data/exercise.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/providers/providers.dart';
import 'package:nice/shared/providers/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_exercise_command.g.dart';

@riverpod
class AddExercise extends _$AddExercise with CommandMixin<Exercise> {
  @override
  AsyncValue<Exercise> build() {
    return invalidState();
  }

  Future<void> call(DailyTraining training, Exercise exercise) async {
    state = const AsyncLoading();
    final repository = ref.read(trainingRepositoryProvider);
    training.addExercise(exercise);
    final result = await repository.store(training);
    state = switch (result) {
      Ok() => AsyncData(exercise),
      Err(value: final err) => AsyncError(err, StackTrace.current),
    };
  }
}
```

### Naming Conventions

- Name command files with `*_command.dart` suffix
- Class name should be an action verb: `AddExercise`, `UpdateExercise`, `DeleteExercise`
- The `call()` method signature should be clear and explicit

### State Management Pattern

Commands follow a consistent state pattern using `CommandMixin`:

1. **Initial state**: Return `invalidState()` in `build()` (indicates command not yet called)
2. **Loading**: Set `state = const AsyncLoading()` at the start of `call()`
3. **Success/Error**: Handle `Result` type with pattern matching

```dart
state = switch (result) {
  Ok() => AsyncData(successValue),
  Err(value: final err) => AsyncError(err, StackTrace.current),
};
```

**Why `invalidState()` instead of `AsyncData(Entity.empty())`?**
- Commands represent actions, not data - they start in an "uncalled" state
- Prevents UI from mistakenly treating initial state as valid data
- Makes it explicit that the command has not been executed yet

### Best Practices

- Always use `CommandMixin<T>` for command providers
- Use `invalidState()` as the initial state in `build()`
- Delegate business logic to entities (domain methods)
- Use repositories for persistence only
- Return meaningful values on success
- Handle errors explicitly with `AsyncError`
- Use `Unit` type when no return value is needed
- Commands can call other commands when needed
- Commands are global elements of the application (accessible from any feature)
- Use `ref.mounted` checks when setting state asynchronously (provided by mixin)

## File Organization

```
lib/features/<feature>/
├── data/
│   ├── <entity>.dart
│   └── <repository>.dart
├── providers/
│   ├── providers.dart           # Service providers (all data elements)
│   ├── <name>_query.dart        # Query providers (pre-customized data sources)
│   ├── <action>_command.dart    # Command providers (use cases)
│   └── *.g.dart                 # Generated files
└── ui/
    └── *.dart

lib/shared/
├── provider.dart                # Shared service providers ONLY (no commands/queries)
├── providers/
│   └── command_provider_base_mixin.dart  # CommandMixin for all commands
└── ...
```

## Examples

### DO: Proper Query Provider

```dart
// lib/features/trainning/providers/training_from_id_query.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/training.dart';
import 'providers.dart';

part 'training_from_id_query.g.dart';

@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}
```

### DO: Proper Command Provider

```dart
// lib/features/trainning/providers/update_exercise_command.dart
import 'package:nice/shared/providers/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/exercise.dart';
import '../data/exercise_positioned.dart';
import '../data/training.dart';
import 'providers.dart';

part 'update_exercise_command.g.dart';

@riverpod
class UpdateExercise extends _$UpdateExercise with CommandMixin<Exercise> {
  @override
  AsyncValue<Exercise> build() {
    return invalidState();
  }

  Future<void> call(
    DailyTraining training, {
    required PositionedExercise exercise,
  }) async {
    final repo = ref.read(trainingRepositoryProvider);
    state = const AsyncLoading();
    training.setExercise(exercise);
    final result = await repo.store(training);
    state = switch (result) {
      Ok() => AsyncData(exercise.value),
      Err(value: final err) => AsyncError(err, StackTrace.current),
    };
  }
}
```

### DO: Command with Unit Return Type

```dart
// lib/features/trainning/providers/merge_exercises_command.dart
import 'package:nice/shared/providers/command_provider_base_mixin.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/exercise_positioned.dart';
import '../data/training.dart';
import 'providers.dart';

part 'merge_exercises_command.g.dart';

@riverpod
class MergeExercises extends _$MergeExercises with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() {
    return invalidState();
  }

  Future<void> call(
    DailyTraining training, {
    required List<PositionedExercise> exercises,
  }) async {
    state = const AsyncLoading();
    training.mergeExercises(exercises);
    final result = await ref.read(trainingRepositoryProvider).store(training);
    state = switch (result) {
      Ok() => const AsyncData(unit),
      Err(value: final err) => AsyncError(err, StackTrace.current),
    };
  }
}
```

### DON'T: Business Logic in Provider

```dart
// BAD: Business logic in provider
@riverpod
class AddExercise extends _$AddExercise with CommandMixin<Exercise> {
  @override
  AsyncValue<Exercise> build() => invalidState();

  Future<void> call(DailyTraining training, Exercise exercise) async {
    // BAD: Validation logic belongs in the entity
    if (exercise.name.isEmpty) {
      state = AsyncError('Name required', StackTrace.current);
      return;
    }
    
    // BAD: Business rules should be in entity methods
    if (training.exercises.length >= 10) {
      state = AsyncError('Max exercises reached', StackTrace.current);
      return;
    }
    
    // ... rest of implementation
  }
}
```

### DON'T: Multiple Responsibilities

```dart
// BAD: Provider doing too much
@riverpod
class ExerciseManager extends _$ExerciseManager with CommandMixin<void> {
  @override
  AsyncValue<void> build() => invalidState();

  // BAD: Multiple actions in one provider
  Future<void> add(DailyTraining t, Exercise e) async { ... }
  Future<void> update(DailyTraining t, Exercise e) async { ... }
  Future<void> delete(DailyTraining t, Exercise e) async { ... }
  Future<void> merge(DailyTraining t, List<Exercise> e) async { ... }
}
```

### DON'T: Command Without CommandMixin

```dart
// BAD: Missing CommandMixin and invalidState()
@riverpod
class AddExercise extends _$AddExercise {
  @override
  AsyncValue<Exercise> build() {
    // BAD: Should use invalidState() with CommandMixin
    return AsyncData(Exercise.empty());
  }

  Future<void> call(DailyTraining training, Exercise exercise) async {
    // BAD: No ref.mounted checks for async state updates
    state = const AsyncLoading();
    // ...
  }
}
```

### DON'T: Field-Specific Updates

```dart
// BAD: Direct field updates bypass entity business rules
@riverpod
class UpdateExerciseName extends _$UpdateExerciseName {
  Future<void> call(String id, String newName) async {
    // BAD: Should modify entity and call store()
    await repository.updateName(id, newName);
  }
}
```

## Consuming Providers in UI

### Reading Commands

Use `ref.read()` to get notifier for commands in `initState` or callbacks:

```dart
class _MyWidgetState extends ConsumerState<MyWidget> {
  late final _addExercise = ref.read(addExerciseProvider.notifier);
  late final _deleteExercise = ref.read(deleteExerciseProvider.notifier);

  void _handleAdd() {
    _addExercise(training, exercise);
  }
}
```

### Watching Queries

Use `ref.watch()` for reactive data subscriptions:

```dart
@override
Widget build(BuildContext context) {
  final training = ref.watch(trainingFromIdProvider('id'));

  return training.when(
    data: (data) => TrainingView(training: data),
    loading: () => const CircularProgressIndicator(),
    error: (error, stack) => ErrorWidget(error),
  );
}
```

### Listening for Side Effects

Use `ref.listen()` for handling command results:

```dart
@override
Widget build(BuildContext context) {
  ref.listen(addExerciseProvider, (prev, next) {
    if (next is AsyncData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise added successfully')),
      );
    }
  });

  // ... rest of build
}
```

## Code Smells to Avoid

| Smell                              | Problem                                  | Solution                                     |
| ---------------------------------- | ---------------------------------------- | -------------------------------------------- |
| Business logic in provider         | Breaks separation of concerns            | Move logic to entity domain methods          |
| Multiple actions per provider      | Single Responsibility violation          | Create separate command providers            |
| Direct field updates               | Bypasses entity validation               | Modify entity, then call `store()`           |
| Missing loading state              | Poor UX, no feedback                     | Set `AsyncLoading()` before async operations |
| Swallowed errors                   | Silent failures, hard to debug           | Use `AsyncError` with meaningful messages    |
| `ref.watch()` in command methods   | Unexpected rebuilds                      | Use `ref.read()` in methods                  |
| Missing `part` directive           | Code generation won't work               | Include `part 'file.g.dart'`                 |
| Forgetting code generation         | Provider not available                   | Run `dart run build_runner build -d`         |
| Missing `CommandMixin`             | No `invalidState()`, no mounted checks   | Add `with CommandMixin<T>` to commands       |
| Using `AsyncData` in command build | Misleading initial state                 | Use `invalidState()` instead                 |
| Setting state without mounted check| Errors after widget disposal             | Use mixin helpers or check `ref.mounted`     |

## Summary

1. **Categorize providers**: Service, Query, or Command
2. **One responsibility per provider**: Especially for commands
3. **Use `CommandMixin<T>`**: All commands must use the mixin with `invalidState()`
4. **Delegate logic to entities**: Providers orchestrate, don't implement
5. **Handle all states**: Loading, Success, Error
6. **Use Result pattern**: Pattern match on `Ok`/`Err`
7. **Follow naming conventions**: `*_query.dart`, `*_command.dart`
8. **Run code generation**: After modifying annotated providers (`dart run build_runner build -d`)
9. **Location matters**: Shared providers go in `lib/shared/provider.dart` (services only)
10. **Commands are use cases**: They connect business rules with infrastructure
11. **Queries abstract data access**: Pre-customized for UI consumption
12. **Check `ref.mounted`**: Use mixin helpers for safe async state updates
