# AGENTS

Guidance for agentic coders and developers working in this repository.

## Project Overview

- Flutter application (Dart) with Riverpod, Firestore, and odu_core.
- Domain-driven design patterns for entities and repositories.

## Sources of Truth (Read First)

- `.github/instructions/dart.instructions.md`
- `.claude/rules/entities.md`
- `.claude/rules/repositories.md`
- `analysis_options.yaml`

These rules are mandatory unless explicitly overridden by maintainers.

## Build, Lint, Test Commands

Prefer `fvm` when available and prefer `flutter` over `dart`.
Never run `flutter run` (the app is already running).
Always run `flutter analyze` to check health.

### Setup

- `fvm flutter pub get`
- `flutter pub get`

### Code Generation

- `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- `flutter pub run build_runner build --delete-conflicting-outputs`

### Analyze / Lint

- `fvm flutter analyze`
- `flutter analyze`

### Tests (All)

- `fvm flutter test`
- `flutter test`

### Tests (Single Test File)

- `fvm flutter test test/path/to/file_test.dart`
- `flutter test test/path/to/file_test.dart`

### Tests (Single Test Name)

- `fvm flutter test --name "test description"`
- `flutter test --name "test description"`

If no tests exist yet, keep commands in docs for future additions.

## Formatting and Linting Rules

From `analysis_options.yaml` and project standards:

- Use single quotes.
- Require trailing commas; formatter preserves trailing commas.
- Keep widget child properties last.
- Enforce directive ordering (imports).
- Always declare return types.
- Omit local variable types when obvious.
- Prefer `final` for locals.
- Avoid `this` when unnecessary.
- Prefer `??` where appropriate.
- Prefer const constructors.
- Use Riverpod lint rules.

## Imports

- Order imports per `directives_ordering`.
- Avoid unnecessary wildcard exports.
- Keep package imports before relative imports.
- Use `package:` imports for shared code.

## Naming Conventions

- Use clear, descriptive names; avoid abbreviations.
- Dart file names use `snake_case`.
- Class names use `UpperCamelCase`.
- Method/variable names use `lowerCamelCase`.
- Constants use `lowerCamelCase` or `SCREAMING_SNAKE_CASE` only when common.
- Riverpod providers follow `*Provider` naming.

## Types and API Design

- Always declare return types for methods and functions.
- Prefer explicit types for public APIs.
- Avoid deep nesting; return early.
- Avoid unnecessary object cloning or copying.
- Avoid long parameter lists; group into objects when needed.
- Use appropriate concurrency control where needed.

## Error Handling

- Use domain-specific failure types where applicable.
- Prefer explicit failure classes (see `EntityFailure`).
- Avoid swallowing errors; surface actionable messages.
- Keep validation pure (no side effects).

## Domain Rules: Entities

Follow `.claude/rules/entities.md`.
Highlights:

- Entities are mutable aggregate roots.
- Public constructor must take all fields.
- Factory methods should use `create()` when helpful.
- Protect internal collections; return unmodifiable views.
- Expose behavior via domain methods, not setters.
- Update `updatedAt` on state changes.
- Implement `validate()` for invariants.
- Use specific failure classes per aggregate root.

## Domain Rules: Repositories

Follow `.claude/rules/repositories.md`.
Highlights:

- One repository per feature/module.
- Repository maps to a single AggregateRoot.
- Repository is data persistence only; no business rules.
- `store(Entity)` for create/update.
- `find*` for queries.
- `delete()` deactivates entities (soft delete).
- Do not create field-specific update methods.

## Dart Style and Structure

- Class member order:
  - Static constants, static fields, static methods
  - Factory constructors, constructors
  - Public fields with getters/setters
  - Private fields with getters/setters
  - Protected fields with getters/setters
  - Public methods, private methods, protected methods
- Constructors: injected instances must be named and `required`.
- Favor composition over inheritance.
- Keep functions small and single-purpose.

## Code Smell Checklist

From project instructions:

- Avoid mysterious names; rename for clarity.
- Eliminate duplicate code via extraction.
- Break long functions and large classes.
- Avoid long parameter lists; use parameter objects.
- Prevent divergent change and shotgun surgery by regrouping responsibilities.
- Move feature envy to the right class.
- Replace primitive obsession with value objects.

## Project Structure Notes

- Features are under `lib/features/`.
- Data layer and repository logic live under `lib/features/*/data/`.
- UI and widgets live under `lib/features/*/ui/`.
- Shared utilities are under `lib/shared/`.

## When Adding New Code

- Match existing file structure and naming patterns.
- Keep dependencies minimal.
- Prefer Riverpod for state management.
- Avoid `flutter run` and use analysis to validate changes.

## Agent Behavior Requirements

- Use Mac-friendly commands.
- If generated code exceeds 20 lines, consider consolidation.
- Keep comments focused on non-obvious intent.
- Document public APIs only when necessary.
