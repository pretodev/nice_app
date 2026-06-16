---
name: new-feature-module
description: Scaffold a new feature following this project's data/state/ui + module-injector convention, and wire it into main.dart.
disable-model-invocation: true
---

# new-feature-module

Scaffold a new feature `<name>` under `lib/features/<name>/`, matching the existing
structure (see `lib/features/training/`). Take the feature name from the argument.

## Layout to create

```
lib/features/<name>/
  data/                     # repositories, data sources, models (Result-returning)
  state/                    # <Name>ViewModel + <Name>State
  ui/                       # screens & widgets
  <name>_module.dart        # Module wiring
```

## Steps

1. **Module** (`<name>_module.dart`): extend `Module`. Add `imports => [appModule]`
   if it needs shared bindings (e.g. `FirebaseAuth`, `FirebaseFirestore`). Register
   internals as private `lazySingleton`; `export` only what the UI/other modules
   resolve (typically the ViewModel).

   ```dart
   import 'package:nice/core/injector/module.dart';
   import 'package:nice/features/app/app_module.dart';

   class <Name>Module extends Module {
     @override
     List<Module> get imports => [appModule];

     @override
     void registry(Registry r) {
       r.lazySingleton<<Name>Repository>((i) => <Name>Repository(/* i.get(...) */));
       r.export.lazySingleton<<Name>ViewModel>(
         (i) => <Name>ViewModel(i.get<<Name>Repository>()),
       );
     }
   }
   ```

2. **ViewModel** (`state/<name>_view_model.dart`): extend `ViewModel<<Name>State>`,
   mutate via `emit(...)`, expose actions as `late final doX = _doX.bind();` where
   `_doX` returns `FutureResult<...>`. State is an `Equatable` immutable class with
   `copyWith`. (Pattern: `lib/features/training/state/training_view_model.dart`.)

3. **Repository / data** (`data/`): return `FutureResult<T>` from
   `package:nice/core/fp/fp.dart`; do not throw for expected failures.

4. **Wire it**: add `<Name>Module()` to the `createInjector([...])` list in
   `lib/main.dart`.

5. Run `flutter analyze` and confirm clean.

## Conventions (enforced by lints)

- `package:nice/...` imports only — no relative imports.
- Single quotes, explicit return types, `const` constructors where possible,
  trailing commas preserved.
