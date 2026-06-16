---
name: gen-test
description: Generate a flutter_test + mocktail test for a Dart class in this project (repository, ViewModel, or injector module), following project conventions.
disable-model-invocation: true
---

# gen-test

Generate a test for the Dart file/class named in the argument, mirroring the
patterns already used in this repo. Place the test under `test/` at the path that
mirrors the `lib/` path (e.g. `lib/features/training/data/training_repository.dart`
→ `test/features/training/data/training_repository_test.dart`).

## Steps

1. Read the target file and its direct collaborators to learn the constructor
   shape and which dependencies must be doubled.
2. Decide the harness:
   - **Repository / plain class**: construct directly, pass `mocktail` mocks for
     collaborators.
   - **ViewModel**: construct with mocked collaborators; drive `Command`s via
     `await vm.someCommand(...)`; assert on `vm.state`, `vm.someCommand.isDone`,
     `vm.someCommand.isError`.
   - **Module / DI wiring**: use `createInjector([Module()], overrides: {Type: double})`
     and assert resolution / visibility, like `test/core/injector/module_injector_test.dart`.
3. Use `mocktail`: `class _MockX extends Mock implements X {}`, `when(() => ...)`,
   `verify(() => ...)`. Register fallback values in `setUpAll` if matchers need them.
4. Respect lints: single quotes, `package:nice/...` imports (no relative imports),
   trailing commas, explicit return types.
5. After writing, run `flutter test <new_file>` and fix until green.

## Reference patterns

Result types come from `package:nice/core/fp/fp.dart` (`Ok`/`Err`/`ok`/`Unit`,
`FutureResult`). Commands expose `isIdle/isWaiting/isDone/isError`, `value`, `failure`.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nice/core/fp/fp.dart';
// import the unit under test + its collaborators

class _MockTrainingDocument extends Mock implements FirestoreTrainingDocument {}

void main() {
  late _MockTrainingDocument doc;
  late TrainingRepository repository;

  setUp(() {
    doc = _MockTrainingDocument();
    repository = TrainingRepository(trainingDocument: doc);
  });

  test('store upserts the training and returns ok', () async {
    when(() => doc.upsert(any())).thenAnswer((_) async {});

    final training = /* build a DailyTraining */;
    final result = await repository.store(training);

    expect(result.isOk, isTrue);
    verify(() => doc.upsert(training)).called(1);
  });
}
```

For ViewModels, prefer injecting doubles directly into the constructor; only reach
for `createInjector(..., overrides: {...})` when testing the wiring itself.
