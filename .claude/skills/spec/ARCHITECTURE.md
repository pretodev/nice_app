# Architecture Reference

Quick reference for Nice App architecture patterns.

## Provider Organization

Providers organized in `/features/*/providers/`:

```
providers/
├── provider_services.dart   # Singleton dependencies
├── provider_queries.dart    # Stream-based queries
└── commands/                # Async operations
    └── [name]_command.dart
```

## Command Pattern

```dart
@riverpod
class MyCommand extends _$MyCommand with CommandMixin<ResultType> {
  @override
  AsyncValue<ResultType> build() => invalidState();

  Future<void> call(params) async {
    emitLoading();
    final result = await _executeLogic();
    emitResult(result);
  }
}
```

**CommandMixin methods**:
- `emitLoading()` - Sets AsyncLoading state
- `emitData(T)` - Emits success with data
- `emitError(E)` - Emits error state
- `emitResult(Result<T>)` - Converts Result to AsyncValue

## Repository Pattern

```dart
class FeatureRepository {
  // Store/update entity
  FutureResult<Unit> store(Entity entity) async { ... }

  // Delete entity
  FutureResult<Unit> delete(Entity entity) async { ... }

  // Stream by ID (reactive)
  Stream<Entity> fromId(String id) { ... }
}
```

**Rules**:
- Single source of truth
- No business logic
- Uses streams for reactive data
- Can have multiple data sources
- Cannot access other repositories or services

## Query Pattern

```dart
@riverpod
Stream<DataType> myQuery(Ref ref, String param) {
  final repository = ref.watch(repositoryProvider);
  return repository.fromId(param);
}
```

**Rules**:
- Aggregates reactive data
- No business logic
- Uses Riverpod for reactivity

## View Pattern

```dart
class MyView extends ConsumerStatefulWidget {
  // Static navigation method for pages
  static PageRoute<void> route({required Entity entity}) {
    return MaterialPageRoute<void>(
      builder: (context) => MyView(entity: entity),
    );
  }

  // Static method for modals
  static Future<void> show({
    required BuildContext context,
    required Entity entity,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => MyView(entity: entity),
    );
  }

  // ...
}
```

## Widget Pattern

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({
    required this.data,
    required this.onAction,
    super.key,
  });

  final DataType data;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) { ... }
}
```

**Rules**:
- StatelessWidget
- No business logic
- Visual representation only

## Domain Model Patterns

### Sealed Classes

```dart
sealed class ExerciseSet {
  List<Exercise> get exercises;
}

class StraightSet extends ExerciseSet {
  final Exercise exercise;
  @override
  List<Exercise> get exercises => [exercise];
}

class BiSet extends ExerciseSet {
  final Exercise exercise1;
  final Exercise exercise2;
  @override
  List<Exercise> get exercises => [exercise1, exercise2];
}
```

### Positioned Wrapper

```dart
class PositionedExercise {
  final Exercise exercise;
  final int externalIndex;  // Position in parent list
  final int internalIndex;  // Position within set
}
```

## Result/Error Handling

Uses `Result<T>` from `odu_core`:

```dart
// Success
return Result.ok(data);

// Error
return Result.err(Failure.message('Error description'));

// Chaining
result
  .map((data) => transform(data))
  .flatMapAsync((data) => asyncOperation(data));
```

## Firestore Integration

```dart
class FirestoreFeatureDocument
    extends FirestoreCustomDocumentReference<Entity> {

  Entity fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Entity.fromMap(data);
  }

  Map<String, dynamic> toFirestore(Entity entity) {
    return entity.toMap();
  }
}
```

## Shared Resources

Located in `lib/shared/`:

| Resource | Location | Purpose |
|----------|----------|---------|
| CommandMixin | `mixins/command_provider_base_mixin.dart` | Command state management |
| FirestoreCustomDocumentReference | `data/firestore/firestore_custom_reference.dart` | Firestore abstraction |
| Environment | `environment.dart` | Config from environment |

## Code Generation

Run after model/provider changes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
