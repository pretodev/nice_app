---
name: ManageProviderQuery
description: Guidelines for creating and maintaining query providers, which abstract data fetching for UI consumption in Flutter/Riverpod.
---

Query providers are pre-customized data sources that abstract access to certain data, making it ready to be consumed by the UI. They fetch data and provide reactive streams or async values.

## When to Use Query Providers

Use a Query Provider when you need to:

- Fetch data for UI consumption
- Create reactive data streams
- Abstract data access with pre-configured parameters
- Provide one-time async data fetches
- Combine or transform data from repositories

## Location

Query providers are located within feature directories:

**Path**: `lib/features/<feature>/providers/<name>_query.dart`

```
lib/features/<feature>/providers/
├── providers.dart              # Service providers
├── <name>_query.dart           # Query providers (pre-customized data sources)
├── <action>_command.dart       # Command providers
└── *.g.dart                    # Generated files
```

## Structure

Query providers are simple functions that fetch and return data:

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

## Naming Conventions

| Element       | Convention                        | Example                         |
| ------------- | --------------------------------- | ------------------------------- |
| File name     | `*_query.dart`                    | `training_from_id_query.dart`   |
| Function name | Descriptive of data being fetched | `trainingFromId`, `usersByRole` |
| Provider name | Generated from function           | `trainingFromIdProvider`        |
| Parameters    | Descriptive names                 | `String id`, `UserRole role`    |

## Return Types

### Stream for Real-Time Data

Use `Stream<T>` for data that updates in real-time:

```dart
@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider).fromId(id);
}
```

### Future for One-Time Fetches

Use `Future<T>` for data fetched once:

```dart
@riverpod
Future<UserProfile> userProfile(Ref ref, String userId) {
  return ref.read(userRepositoryProvider).getProfile(userId);
}
```

## Best Practices

| Practice                                | Description                                      |
| --------------------------------------- | ------------------------------------------------ |
| Return `Stream<T>` for real-time data   | Subscriptions that update automatically          |
| Return `Future<T>` for one-time fetches | Data that doesn't need live updates              |
| Use `ref.read()` to access repositories | Avoid `ref.watch()` in query functions           |
| Keep queries simple                     | Just fetch and return data                       |
| No business logic                       | Queries abstract data access, not business rules |
| Name files with `*_query.dart`          | Clear identification of query providers          |
| Use descriptive parameter names         | Makes usage clear at call site                   |

## Examples

### Stream Query with Parameter

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

### Future Query with Multiple Parameters

```dart
// lib/features/users/providers/users_by_role_query.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/user.dart';
import 'providers.dart';

part 'users_by_role_query.g.dart';

@riverpod
Future<List<User>> usersByRole(Ref ref, UserRole role, {int limit = 10}) {
  return ref.read(userRepositoryProvider).findByRole(role, limit: limit);
}
```

### Stream Query for Collections

```dart
// lib/features/trainning/providers/all_trainings_query.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/training.dart';
import 'providers.dart';

part 'all_trainings_query.g.dart';

@riverpod
Stream<List<DailyTraining>> allTrainings(Ref ref) {
  return ref.read(trainingRepositoryProvider).watchAll();
}
```

### Query with Date Range

```dart
// lib/features/analytics/providers/metrics_in_range_query.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/metric.dart';
import 'providers.dart';

part 'metrics_in_range_query.g.dart';

@riverpod
Future<List<Metric>> metricsInRange(
  Ref ref,
  DateTime startDate,
  DateTime endDate,
) {
  return ref.read(analyticsRepositoryProvider).getMetrics(startDate, endDate);
}
```

## Maintenance and Modification

When modifying existing queries:

1.  **Parameter Updates**: If adding parameters, update all call sites. Consider using named parameters for optional filters.
2.  **Performance Check**: Ensure new logic doesn't introduce blocking operations. Queries should be lightweight.
3.  **No Side Effects**: Verify that no side effects (like API writes or state mutations) are added.
4.  **Refactor**: If a query becomes complex, consider moving logic to the repository or creating a specific repository method.

## Consuming Queries in UI

### Watching Queries

Use `ref.watch()` for reactive data subscriptions:

```dart
@override
Widget build(BuildContext context) {
  final training = ref.watch(trainingFromIdProvider('training-123'));

  return training.when(
    data: (data) => TrainingView(training: data),
    loading: () => const CircularProgressIndicator(),
    error: (error, stack) => ErrorWidget(error),
  );
}
```

### Watching with Parameters

```dart
@override
Widget build(BuildContext context) {
  final users = ref.watch(usersByRoleProvider(UserRole.admin, limit: 20));

  return users.when(
    data: (userList) => UserListView(users: userList),
    loading: () => const LoadingIndicator(),
    error: (error, stack) => ErrorView(error: error),
  );
}
```

## Anti-Patterns to Avoid

### ❌ DON'T: Business Logic in Query

```dart
// BAD: Business logic doesn't belong in queries
@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  return ref.read(trainingRepositoryProvider)
      .fromId(id)
      .map((training) {
        // BAD: Business logic in query
        if (training.exercises.isEmpty) {
          training.addDefaultExercise();
        }
        return training;
      });
}
```

### ❌ DON'T: Mutations in Query

```dart
// BAD: Queries should not mutate data
@riverpod
Future<User> userProfile(Ref ref, String userId) async {
  final user = await ref.read(userRepositoryProvider).getProfile(userId);

  // BAD: Don't mutate in queries
  user.lastAccessed = DateTime.now();
  await ref.read(userRepositoryProvider).save(user);

  return user;
}
```

### ❌ DON'T: Complex Transformations

```dart
// BAD: Complex logic should be in the entity or a use case
@riverpod
Future<TrainingSummary> trainingSummary(Ref ref, String id) async {
  final training = await ref.read(trainingRepositoryProvider).fromId(id).first;

  // BAD: This logic belongs in the entity
  final totalVolume = training.exercises.fold(0, (sum, e) => sum + e.volume);
  final avgIntensity = training.exercises.map((e) => e.intensity).average;
  final muscleGroups = training.exercises.map((e) => e.muscleGroup).toSet();

  return TrainingSummary(
    totalVolume: totalVolume,
    avgIntensity: avgIntensity,
    muscleGroups: muscleGroups,
  );
}
```

### ❌ DON'T: Use `ref.watch()` Inside Query

```dart
// BAD: Don't use ref.watch() in query functions
@riverpod
Stream<DailyTraining> trainingFromId(Ref ref, String id) {
  // BAD: Use ref.read() instead
  final repo = ref.watch(trainingRepositoryProvider);
  return repo.fromId(id);
}
```

## Code Smells

| Smell                   | Problem                            | Solution                            |
| ----------------------- | ---------------------------------- | ----------------------------------- |
| Business logic in query | Breaks separation of concerns      | Move logic to entity domain methods |
| Mutations in query      | Queries should be read-only        | Use a command for mutations         |
| Complex transformations | Query doing too much               | Move to entity methods or use case  |
| Using `ref.watch()`     | Unnecessary reactivity in provider | Use `ref.read()` in queries         |
| Missing file suffix     | Hard to identify query providers   | Name files with `*_query.dart`      |
| Non-descriptive names   | Unclear what data is fetched       | Use descriptive function names      |

## Code Generation

Always include the part directive and run code generation after changes:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'your_query.g.dart';
```

```bash
dart run build_runner build -d
```

**Note**: The `-d` flag is short for `--delete-conflicting-outputs`.
