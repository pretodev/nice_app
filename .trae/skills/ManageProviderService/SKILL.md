---
name: ManageProviderService
description: Guidelines for creating and maintaining service providers, which handle dependency injection in Flutter/Riverpod.
---

Service providers handle dependency injection for repositories, clients, and other services. They are the simplest type of provider, focused solely on wiring dependencies together.

## When to Use Service Providers

Use a Service Provider when you need to:

- Provide dependency injection for repositories
- Wire up external clients or services
- Create shared infrastructure components
- Provide data layer elements to features

## Provider Types Overview

| Type        | Purpose                                     | Naming Pattern           | Example                      |
| ----------- | ------------------------------------------- | ------------------------ | ---------------------------- |
| **Service** | Dependency injection for services           | `*Provider`              | `trainingRepositoryProvider` |
| Query       | Pre-customized data sources for UI          | `*Query` or `*Provider`  | `trainingFromIdProvider`     |
| Command     | Use cases with loading/success/error states | `*Command` or class name | `addExerciseProvider`        |

## Location

Service providers have two possible locations based on scope:

### Feature-Specific Services

**Path**: `lib/features/<feature>/providers/providers.dart`

Use this for services that belong to a specific feature module.

### Shared Services

**Path**: `lib/shared/provider.dart`

Use this for services shared across multiple features.

> ⚠️ **Important**: Only service providers go in `lib/shared/provider.dart`. Never place commands or queries there.

```
lib/features/<feature>/
├── data/
│   ├── <entity>.dart
│   └── <repository>.dart
├── providers/
│   ├── providers.dart           # Service providers (all data elements)
│   ├── <n>_query.dart           # Query providers
│   └── <action>_command.dart    # Command providers
└── ui/
    └── *.dart

lib/shared/
├── provider.dart                # Shared service providers ONLY
└── providers/
    └── command_provider_base_mixin.dart
```

## Structure

Service providers are simple functions that wire dependencies:

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

## Naming Conventions

| Element       | Convention                                             | Example                      |
| ------------- | ------------------------------------------------------ | ---------------------------- |
| File name     | `providers.dart` (feature) or `provider.dart` (shared) | `providers.dart`             |
| Function name | Noun describing the service                            | `trainingRepository`         |
| Provider name | Generated with `Provider` suffix                       | `trainingRepositoryProvider` |

## Best Practices

| Practice                       | Description                                              |
| ------------------------------ | -------------------------------------------------------- |
| Keep providers simple          | Focus only on wiring dependencies                        |
| Use `ref.read()`               | Access other providers when needed                       |
| Avoid business logic           | Services wire, they don't implement logic                |
| One file per feature           | `providers.dart` provides all data elements of a feature |
| Shared services only in shared | `lib/shared/provider.dart` for cross-feature services    |

## Examples

### Feature Service Provider

```dart
// lib/features/auth/providers/providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import '../data/firebase/firebase_auth_client.dart';

part 'providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    authClient: FirebaseAuthClient(),
  );
}
```

### Service with Dependencies

```dart
// lib/features/notifications/providers/providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/notification_repository.dart';
import '../data/firebase/firebase_messaging_client.dart';
import '../../auth/providers/providers.dart';

part 'providers.g.dart';

@riverpod
NotificationRepository notificationRepository(Ref ref) {
  final authRepo = ref.read(authRepositoryProvider);

  return NotificationRepository(
    messagingClient: FirebaseMessagingClient(),
    authRepository: authRepo,
  );
}
```

### Shared Service Provider

```dart
// lib/shared/provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/analytics_client.dart';
import 'data/crash_reporter.dart';

part 'provider.g.dart';

@riverpod
AnalyticsClient analyticsClient(Ref ref) {
  return AnalyticsClient();
}

@riverpod
CrashReporter crashReporter(Ref ref) {
  return CrashReporter();
}
```

## Maintenance and Modification

When modifying existing service providers:

1.  **Dependency Updates**: If a service's constructor changes (e.g., new dependency), update the provider to supply it using `ref.read()` if it comes from another provider.
2.  **Scope Management**: If a service needs to be promoted from feature-specific to shared, move it to `lib/shared/provider.dart` and update imports.
3.  **Cleanup**: If a service is no longer used, remove the provider to keep the dependency graph clean.

## Anti-Patterns to Avoid

### ❌ DON'T: Business Logic in Service Provider

```dart
// BAD: Business logic doesn't belong here
@riverpod
TrainingRepository trainingRepository(Ref ref) {
  final repo = TrainingRepository(
    trainingDocument: FirestoreTrainningDocument(),
  );

  // BAD: Don't add business logic
  if (someCondition) {
    repo.enableCaching();
  }

  return repo;
}
```

### ❌ DON'T: Commands in Shared Provider File

```dart
// lib/shared/provider.dart

// BAD: Commands should NOT be in shared provider file
@riverpod
class SomeGlobalCommand extends _$SomeGlobalCommand {
  // This belongs in a feature's providers folder
}
```

### ❌ DON'T: Queries in Shared Provider File

```dart
// lib/shared/provider.dart

// BAD: Queries should NOT be in shared provider file
@riverpod
Stream<User> currentUser(Ref ref) {
  // This belongs in a feature's providers folder
}
```

### ❌ DON'T: Complex Initialization Logic

```dart
// BAD: Too much logic for a service provider
@riverpod
Future<DatabaseClient> databaseClient(Ref ref) async {
  final client = DatabaseClient();

  // BAD: Complex initialization belongs elsewhere
  await client.connect();
  await client.runMigrations();
  await client.seedData();

  return client;
}
```

## Code Smells

| Smell                               | Problem                            | Solution                                |
| ----------------------------------- | ---------------------------------- | --------------------------------------- |
| Business logic in service provider  | Breaks separation of concerns      | Keep services as pure dependency wiring |
| Commands/Queries in shared provider | Wrong location                     | Move to feature providers folder        |
| Complex initialization              | Service providers should be simple | Use a dedicated initializer or command  |
| Using `ref.watch()`                 | Unnecessary reactivity             | Use `ref.read()` in service providers   |

## Code Generation

Always include the part directive and run code generation after changes:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';
```

```bash
dart run build_runner build -d
```

**Note**: The `-d` flag is short for `--delete-conflicting-outputs`.
