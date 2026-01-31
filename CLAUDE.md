# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Generate code (Riverpod providers, freezed models)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Static analysis
flutter analyze

# Format code
dart format lib/
```

## Architecture Overview

**Nice App** is a Flutter fitness training application with AI-powered exercise generation. It uses Firebase Firestore for persistence and OpenRouter API for multimodal AI training creation.

### Tech Stack
- Flutter with Dart 3.10.4+
- Riverpod 3.1.0 with code generation (`@riverpod` annotations)
- Firebase Firestore
- OpenRouter API (GPT-4.5-image-mini)
- Custom `odu_core` package providing Result/Option types

### Provider Organization Pattern

Providers are organized into three categories in `/features/*/providers/`:

1. **Service Providers** (`provider_services.dart`): Singleton dependencies (Repository, API clients)
2. **Query Providers** (`provider_queries.dart`): Stream-based data queries
3. **Command Providers** (`commands/`): Async operations using `CommandMixin<T>`

Command provider pattern:
```dart
@riverpod
class MyCommand extends _$MyCommand with CommandMixin<ResultType> {
  @override
  AsyncValue<ResultType> build() => invalidState();

  Future<void> call(params) async {
    emitLoading();
    final result = await _executeLogic();
    emitResult(result);  // Converts Result<T> to AsyncValue<T>
  }
}
```

### Data Model Patterns

**Sealed classes** for type-safe exercise modeling:
- `ExerciseSet`: `StraightSet` (1), `BiSet` (2), or `TriSet` (3 exercises)
- `ExerciseExecution`: `TimedExerciseExecution` or `SerializedExerciseExecution`

**Exercise positioning**: External index (set position in list) + internal index (position within set) enables precise editing of combined sets.

### Key Directories

- `lib/features/trainning/` - Main training feature (note: folder has typo "trainning")
- `lib/features/aigen/` - OpenRouter AI integration
- `lib/shared/` - Shared utilities, Firestore base classes, CommandMixin

### Result/Error Handling

Uses `Result<T>` from `odu_core` package (Ok/Err pattern). CommandMixin converts Results to AsyncValue for UI consumption.

### Environment Configuration

OpenRouter API key loaded via `String.fromEnvironment('OPEN_ROUTER_API_KEY')` - see `env.example.json` for template.
