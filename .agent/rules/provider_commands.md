---
trigger: model_decision
description: When the user asks to create, modify, or review a command provider, use case, action provider, or any provider that handles mutations, state changes, or async operations with side effects in Flutter/Riverpod.
---

Commands are use cases that handle mutations and side effects. They connect business rules with infrastructure and have triple states: loading, success, and error.

## When to Use

- Perform mutations (create, update, delete)
- Handle async operations with loading/success/error feedback
- Connect business rules with infrastructure layers

## Location

**Path**: `lib/features/<feature>/providers/<action>_command.dart`

## CommandMixin Requirement

All commands **must** use `CommandMixin<T>` from `lib/shared/providers/command_provider_base_mixin.dart`.

| Method                                 | Purpose                                     |
| -------------------------------------- | ------------------------------------------- |
| `invalidState()`                       | Returns error state for initial build       |
| `emitLoading()`                        | Sets loading state with `ref.mounted` check |
| `emitData(T data)`                     | Sets success state, returns `Ok(data)`      |
| `emitError<E>(E error, [StackTrace?])` | Sets error state, returns `Err(error)`      |
| `emitResult(Result<T>, [StackTrace?])` | Handles Result pattern automatically        |

### Mixin Implementation

```dart
// lib/shared/providers/command_provider_base_mixin.dart
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

AsyncValue<T> invalidState<T>() => AsyncError<T>(
  StateError('Not called yet'),
  StackTrace.current,
);

mixin CommandMixin<T> on $Notifier<AsyncValue<T>> {
  Result<T> emitError<E extends Exception>(E error, [StackTrace? stackTrace]) {
    if (ref.mounted) {
      state = AsyncError(error, stackTrace ?? StackTrace.current);
    }
    return Err(error, stackTrace ?? StackTrace.current);
  }

  Result<T> emitData(T data) {
    if (ref.mounted) {
      state = AsyncData(data);
    }
    return Ok(data);
  }

  void emitLoading() {
    if (ref.mounted) {
      state = const AsyncLoading();
    }
  }

  Result<T> emitResult(Result<T> result, [StackTrace? stackTrace]) {
    if (ref.mounted) {
      state = switch (result) {
        Ok<T>(value: final data) => AsyncData(data),
        Err<T>(value: final error) => AsyncError(
          error,
          stackTrace ?? StackTrace.current,
        ),
      };
    }
    return result;
  }
}
```

## Structure

```dart
@riverpod
class AddExercise extends _$AddExercise with CommandMixin<Exercise> {
  @override
  AsyncValue<Exercise> build() {
    return invalidState();
  }

  Future<void> call(DailyTraining training, Exercise exercise) async {
    emitLoading();
    final repository = ref.read(trainingRepositoryProvider);
    training.addExercise(exercise);
    final result = await repository.store(training).map((_) => exercise);
    emitResult(result);
  }
}
```

## Naming Conventions

| Element    | Convention       | Example                     |
| ---------- | ---------------- | --------------------------- |
| File name  | `*_command.dart` | `add_exercise_command.dart` |
| Class name | Action verb      | `AddExercise`, `UpdateUser` |
| Method     | Always `call()`  | `Future<void> call(...)`    |

## Return Types

### `Future<void>` - Fire and Forget

```dart
Future<void> call(DailyTraining training, Exercise exercise) async {
  emitLoading();
  final result = await repository.store(training).map((_) => exercise);
  emitResult(result);
}
```

### `FutureResult<T>` - Caller Needs Result

```dart
FutureResult<Exercise> call(
  DailyTraining training, {
  required PositionedExercise exercise,
}) async {
  emitLoading();
  training.setExercise(exercise);
  final result = await ref
      .read(trainingRepositoryProvider)
      .store(training)
      .map((_) => exercise.value);
  return emitResult(result);
}
```

## Command with Unit Return Type

```dart
@riverpod
class MergeExercises extends _$MergeExercises with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() => invalidState();

  Future<void> call(
    DailyTraining training, {
    required List<PositionedExercise> exercises,
  }) async {
    emitLoading();
    training.mergeExercises(exercises);
    final result = await ref
        .read(trainingRepositoryProvider)
        .store(training)
        .map((_) => unit);
    emitResult(result);
  }
}
```

## Anti-Patterns

### ❌ Business Logic in Provider

```dart
// BAD: Validation belongs in entity
Future<void> call(DailyTraining training, Exercise exercise) async {
  if (exercise.name.isEmpty) {
    emitError(ValidationException('Name required'));
    return;
  }
  // ...
}
```

### ❌ Multiple Responsibilities

```dart
// BAD: One action per provider
class ExerciseManager extends _$ExerciseManager with CommandMixin<void> {
  Future<void> add(...) async { ... }
  Future<void> update(...) async { ... }
  Future<void> delete(...) async { ... }
}
```

### ❌ Command Without CommandMixin

```dart
// BAD: Missing mixin and invalidState()
class AddExercise extends _$AddExercise {
  @override
  AsyncValue<Exercise> build() => AsyncData(Exercise.empty());
}
```

### ❌ Manual State Switching

```dart
// BAD: Use emitResult() instead
state = switch (result) {
  Ok() => AsyncData(exercise),
  Err(value: final err) => AsyncError(err, StackTrace.current),
};
```

## Code Smells

| Smell                         | Solution                      |
| ----------------------------- | ----------------------------- |
| Business logic in provider    | Move to entity domain methods |
| Multiple actions per provider | Create separate commands      |
| Missing loading state         | Call `emitLoading()`          |
| `ref.watch()` in methods      | Use `ref.read()`              |
| `AsyncData` in build          | Use `invalidState()`          |
| Manual state switching        | Use `emitResult()`            |

## Code Generation

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'your_command.g.dart';
```

```bash
dart run build_runner build -d
```
