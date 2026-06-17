# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Run the app (OpenRouter key passed via dart-define)
flutter run --dart-define=OPEN_ROUTER_API_KEY=...

# Run all tests
flutter test

# Run a single test file
flutter test test/core/injector/module_injector_test.dart

# Static analysis (strict lints — see analysis_options.yaml)
flutter analyze

# Format code (note: trailing_commas are preserved, not auto-added)
dart format lib/ test/
```

> There is **no code generation** in this project — no `build_runner`, `freezed`,
> or `riverpod`. Do not add codegen steps.

### Agentic Hot Reload (Dart 3.12 / Flutter 3.44)

This project is wired for **Agentic Hot Reload**. The Dart & Flutter MCP server is
registered project-scoped in `.mcp.json` (`dart mcp-server`), so Claude Code can
discover a running app via the Dart Tooling Daemon and push UI changes without a
manual reload.

Workflow: start the app once with `flutter run --dart-define=OPEN_ROUTER_API_KEY=...`,
then after editing Dart code, hot reload through the MCP server instead of asking
the user to reload. The core loop tools (`mcp__dart__hot_reload`,
`get_runtime_errors`, `get_app_logs`, `get_active_location`, `list_running_apps`,
`analyze_files`, `dart_format`, `widget_inspector`) are pre-approved in
`.claude/settings.json`. `hot_restart`, `launch_app`, and `stop_app` are intentionally
left to prompt.

## Architecture Overview

**Nice App** is a Flutter fitness training application with AI-powered exercise
generation. It uses Firebase Firestore for persistence and the OpenRouter API for
multimodal AI training creation.

### Tech Stack
- Flutter 3.44+ / Dart 3.12+ (the `primary-constructors` experiment is enabled — see `analysis_options.yaml`)
- Firebase: `cloud_firestore`, `firebase_auth`, `firebase_core`
- `dio` for HTTP (OpenRouter client)
- `get_it` as the container behind a custom module injector
- `equatable` for value equality
- `mocktail` for test doubles
- `odu_core` (git dependency) — shared utilities

### Dependency Injection — custom module injector

DI is **not** Riverpod. It is a hand-rolled module system in `lib/core/injector/`
built on top of `get_it`:

- **`Module`** (`module.dart`): pure configuration. Declares `registry(Registry r)`,
  and optionally `imports` (non-transitive access to another module's exports) and
  `parent` (transitive inheritance of a parent's exports). A module holds no runtime
  state, so it can be recomposed many times — essential for tests.
- **`Registry`**: registers bindings via `factory` / `singleton` / `lazySingleton`.
  Bindings are **private by default**; use `r.export.lazySingleton(...)` to expose a
  binding to importers/children.
- **`createInjector(modules, {overrides})`** (`module_injector.dart`): composes the
  tree into a root `Injector`. `overrides` swaps bindings by type — use it to inject
  test doubles.
- **`AppScope`** (`scope.dart`): exposes the injector to the widget tree; resolve with
  `context.read<T>()` / `context.get<T>()`.

Feature modules live next to their feature (e.g. `features/training/training_module.dart`)
and are wired in `lib/main.dart` via `createInjector([...])`.

```dart
class TrainingModule extends Module {
  @override
  List<Module> get imports => [appModule];

  @override
  void registry(Registry r) {
    r.lazySingleton<TrainingRepository>((i) => TrainingRepository(
          trainingDocument: i.get<FirestoreTrainingDocument>(),
        ));
    r.export.lazySingleton<TrainingViewModel>(
      (i) => TrainingViewModel(i.get<TrainingRepository>(), i.get<OpenRouter>()),
    );
  }
}
```

### State management — `ViewModel` + `Command`

State lives in `lib/core/state/`:

- **`ViewModel<T>`** (`view_model.dart`): a `ChangeNotifier` holding immutable state
  `T`; mutate only through the protected `emit(newState)`. State classes are
  `Equatable` with a `copyWith`.
- **`Command<T>`** (`commands.dart`): wraps an async `FutureResult<T>` action with
  status (`isIdle` / `isWaiting` / `isDone` / `isError`). Expose one per action with
  `late final addExercise = _addExercise.bind();` and invoke as `await vm.addExercise(...)`.

### Result / error handling — `lib/core/fp/`

Local functional types (barrel: `package:nice/core/fp/fp.dart`): `Result<T>`
(`Ok`/`Err`), `Option<T>`, `Failure`, `Unit`, and the `FutureResult<T>` /
`FutureOption<T>` aliases. The sentinel `ok` is `Ok(unit)`. Prefer returning
`FutureResult<T>` over throwing; reserve exceptions for the injector
(`DependencyNotFoundException`).

### Data modeling

Sealed-class hierarchies for type-safe exercises:
- `ExerciseSet`: `StraightSet` (1), `BiSet` (2), `TriSet` (3 exercises)
- `ExerciseExecution`: `TimedExerciseExecution` or `SerializedExerciseExecution`

**Exercise positioning**: external index (set position in the list) + internal index
(position within a set) enables precise editing of combined sets.

### Key Directories

- `lib/core/` — `injector/`, `state/` (ViewModel/Command), `fp/` (Result/Option)
- `lib/features/<feature>/` — each with `data/`, `state/`, `ui/`, and a `*_module.dart`
- `lib/features/training/` — main training feature
- `lib/features/aigen/` — OpenRouter AI integration
- `lib/shared/` — shared utilities, Firebase base classes, `environment.dart`

### Environment Configuration

Secrets/config are compile-time constants in `lib/shared/environment.dart` via
`String.fromEnvironment(...)`. Pass them with `--dart-define` (e.g.
`OPEN_ROUTER_API_KEY`). Never hardcode keys.

### Conventions

- Strict lints (`analysis_options.yaml`): single quotes, `package:` imports only
  (no relative imports), explicit return types, `prefer_const_constructors`, trailing
  commas preserved (don't reflow argument lists). Code in Portuguese doc comments is
  the norm — match it.
- New features follow the `data/` + `state/` + `ui/` + `*_module.dart` shape;
  register the module in `main.dart`.
