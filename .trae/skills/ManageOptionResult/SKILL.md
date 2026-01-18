---
name: ManageOptionOrResult
description: Guidelines for working with Option (nullable values) and Result (error handling) types in odu_core.
---

This skill combines guidelines for handling optional values (Option) and operation outcomes (Result).

# Option Type Guidelines

Option is a sealed class for type-safe handling of values that may or may not exist. It replaces nullable types with explicit `Some` and `None`, making absence handling predictable and composable.

## Core Types

| Type              | Purpose                                               |
| ----------------- | ----------------------------------------------------- |
| `Option<T>`       | Wrapper for present (`Some`) or absent (`None`) value |
| `Some<T>`         | Contains a value                                      |
| `None<T>`         | Represents absence of value                           |
| `FutureOption<T>` | Alias for `Future<Option<T>>`                         |

## When to Use Option

- Queries that may return no results
- Optional fields or parameters
- Lookups in collections (find, firstWhere)
- Replacing nullable types for explicit handling
- When absence is a valid, expected state (not an error)

## Option vs Result

| Scenario                       | Use         |
| ------------------------------ | ----------- |
| Value may not exist (expected) | `Option<T>` |
| Operation may fail (error)     | `Result<T>` |
| Query returns 0 or 1 item      | `Option<T>` |
| Network/IO operation           | `Result<T>` |
| Cache lookup                   | `Option<T>` |
| Validation failure             | `Result<T>` |

## Basic Usage (Option)

### Creating Options

```dart
// Present value
Option<User> option = Some(user);

// Absent value
Option<User> option = const None();
```

### Pattern Matching

```dart
switch (option) {
  case Some(value: final user):
    print(user.name);
  case None():
    print('No user found');
}
```

### Unwrapping

```dart
// Throws StateError if None
final user = option.unwrap();

// Returns default if None
final user = option.unwrapOr(User.guest());
```

### Checking State

```dart
if (option.isSome) {
  // Has value
}

if (option.isNone) {
  // No value
}
```

## Transformations (Option)

### map - Transform Value

```dart
Option<String> name = option.map((user) => user.name);
// Some(user) -> Some(user.name)
// None -> None
```

### okOr - Convert to Result

```dart
Result<User> result = option.okOr(Exception('User not found'));
// Some(user) -> Ok(user)
// None -> Err(exception)
```

## FutureOption

Type alias for async options: `typedef FutureOption<T> = Future<Option<T>>`

### Repository Pattern

```dart
abstract class UserRepository {
  FutureOption<User> findById(String id);
  FutureOption<User> findByEmail(String email);
}
```

### Implementation

```dart
class FirestoreUserRepository implements UserRepository {
  @override
  FutureOption<User> findById(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    if (!doc.exists) {
      return const None();
    }
    return Some(User.fromJson(doc.data()!));
  }

  @override
  FutureOption<User> findByEmail(String email) async {
    final query = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return const None();
    }
    return Some(User.fromJson(query.docs.first.data()));
  }
}
```

### Chaining Async Operations

```dart
FutureOption<String> getUserEmail(String id) {
  return userRepository
      .findById(id)
      .map((user) => user.email);
}

FutureOption<Profile> getUserProfile(String id) {
  return userRepository
      .findById(id)
      .flatMapAsync((user) => profileRepository.findByUserId(user.id));
}
```

### Async Extensions

| Method         | Purpose                               |
| -------------- | ------------------------------------- |
| `map`          | Transform value                       |
| `mapAsync`     | Transform with async function         |
| `flatMap`      | Chain with sync Option                |
| `flatMapAsync` | Chain with FutureOption               |
| `filter`       | Keep value if predicate true          |
| `filterAsync`  | Filter with async predicate           |
| `okOr`         | Convert to Result with error          |
| `okOrElse`     | Convert to Result with lazy error     |
| `toNullable`   | Convert to `T?`                       |
| `inspect`      | Side effect on Some                   |
| `withTimeout`  | Add timeout (returns None on timeout) |

### Filtering

```dart
FutureOption<User> findActiveAdmin(String id) {
  return userRepository
      .findById(id)
      .filter((user) => user.isActive)
      .filter((user) => user.role == Role.admin);
}
```

### Converting to Result

```dart
FutureResult<User> getUser(String id) {
  return userRepository
      .findById(id)
      .okOr(Exception('User not found'));
}

FutureResult<User> getUserLazy(String id) {
  return userRepository
      .findById(id)
      .okOrElse(() => NotFoundException('User $id not found'));
}
```

### Converting to Nullable

```dart
Future<User?> findUser(String id) {
  return userRepository
      .findById(id)
      .toNullable();
}
```

## Factory Methods (Option)

```dart
// Create Some
final option = await FutureOptionFactory.some(user);

// Create None
final option = await FutureOptionFactory.none<User>();

// From nullable Future
final option = await FutureOptionFactory.from(nullableFuture);
```

## Best Practices (Option)

| Practice                                  | Description                     |
| ----------------------------------------- | ------------------------------- |
| Use for queries that may return nothing   | `findById`, `findByEmail`, etc. |
| Use `Result` for operations that can fail | Network, IO, validation         |
| Prefer `map`/`flatMap` over unwrap        | Safer transformations           |
| Convert to `Result` at boundaries         | When absence becomes an error   |
| Use `filter` for conditional logic        | Cleaner than nested ifs         |

## Anti-Patterns (Option)

### ❌ Using Option for errors

```dart
// BAD: Errors should use Result
FutureOption<User> saveUser(User user) async {
  try {
    await firestore.collection('users').doc(user.id).set(user.toJson());
    return Some(user);
  } catch (e) {
    return const None(); // Lost error information!
  }
}

// GOOD: Use Result for operations that can fail
FutureResult<User> saveUser(User user) async {
  try {
    await firestore.collection('users').doc(user.id).set(user.toJson());
    return Ok(user);
  } catch (e, s) {
    return Err(e is Exception ? e : Exception('$e'), s);
  }
}
```

### ❌ Ignoring None silently

```dart
// BAD: Silent failure
final user = await userRepository.findById(id).unwrapOr(User.empty());

// GOOD: Explicit handling
final option = await userRepository.findById(id);
switch (option) {
  case Some(value: final user): return showProfile(user);
  case None(): return showNotFound();
}
```

### ❌ Using null instead of None

```dart
// BAD: Mixing null and Option
FutureOption<User> findUser(String id) async {
  final user = await fetchUser(id);
  if (user == null) return const None();
  return Some(user);
}

// GOOD: Use factory method
FutureOption<User> findUser(String id) {
  return FutureOptionFactory.from(fetchUser(id));
}
```

### ❌ Nested Options

```dart
// BAD: Option<Option<T>>
Option<Option<User>> nested = Some(Some(user));

// GOOD: Use flatMap
Option<User> flat = option.flatMap((id) => findUser(id));
```

# Result Type Guidelines

Result is a sealed class for type-safe error handling. It replaces try-catch with explicit `Ok` and `Err` types, making error handling predictable and composable.

## Core Types (Result)

| Type              | Purpose                                        |
| ----------------- | ---------------------------------------------- |
| `Result<T>`       | Wrapper for success (`Ok`) or failure (`Err`)  |
| `Ok<T>`           | Contains success value                         |
| `Err<T>`          | Contains `Exception` and optional `StackTrace` |
| `FutureResult<T>` | Alias for `Future<Result<T>>`                  |
| `Unit`            | Replacement for `void` in Result returns       |
| `unit`            | Singleton instance of `Unit`                   |
| `ok`              | Shorthand for `Ok(unit)`                       |

## When to Use Result

- Repository methods returning data or errors
- Async operations that can fail
- Any function where caller needs to handle success/failure
- Replacing try-catch with explicit error handling

## Basic Usage (Result)

### Creating Results

```dart
// Success
Result<User> result = Ok(user);

// Error
Result<User> result = Err(Exception('Not found'));

// Error with stack trace
Result<User> result = Err(exception, stackTrace);

// Unit for void operations
Result<Unit> result = Ok(unit);
// or use the shorthand
Result<Unit> result = ok;
```

### Pattern Matching (Result)

```dart
switch (result) {
  case Ok(value: final user):
    print(user.name);
  case Err(value: final error):
    print(error);
}
```

### Unwrapping (Result)

```dart
// Throws if Err
final user = result.unwrap();

// Returns default if Err
final user = result.unwrapOr(User.empty());

// Computes value if Err
final user = result.unwrapOrElse((error) => User.guest());
```

## Transformations (Result)

### map - Transform Success Value

```dart
Result<String> name = result.map((user) => user.name);
```

### mapErr - Transform Error

```dart
Result<User> mapped = result.mapErr(
  (error) => CustomException('User error: $error'),
);
```

### flatMap - Chain Results

```dart
Result<Profile> profile = result.flatMap(
  (user) => fetchProfile(user.id),
);
```

## FutureResult

Type alias for async results: `typedef FutureResult<T> = Future<Result<T>>`

### Repository Pattern (Result)

```dart
abstract class UserRepository {
  FutureResult<User> findById(String id);
  FutureResult<Unit> save(User user);
  FutureResult<List<User>> findAll();
}
```

### Implementation (Result)

```dart
class FirestoreUserRepository implements UserRepository {
  @override
  FutureResult<User> findById(String id) async {
    try {
      final doc = await firestore.collection('users').doc(id).get();
      if (!doc.exists) {
        return Err(Exception('User not found'));
      }
      return Ok(User.fromJson(doc.data()!));
    } catch (e, s) {
      return Err(e is Exception ? e : Exception('$e'), s);
    }
  }

  @override
  FutureResult<Unit> save(User user) async {
    try {
      await firestore.collection('users').doc(user.id).set(user.toJson());
      return ok;
    } catch (e, s) {
      return Err(e is Exception ? e : Exception('$e'), s);
    }
  }
}
```

### Chaining Async Operations (Result)

```dart
FutureResult<String> getUserEmail(String id) {
  return userRepository
      .findById(id)
      .map((user) => user.email);
}

FutureResult<Profile> getUserProfile(String id) {
  return userRepository
      .findById(id)
      .flatMapAsync((user) => profileRepository.findByUserId(user.id));
}
```

### Async Extensions (Result)

| Method         | Purpose                          |
| -------------- | -------------------------------- |
| `map`          | Transform success value          |
| `mapAsync`     | Transform with async function    |
| `mapErr`       | Transform error                  |
| `flatMap`      | Chain with sync Result           |
| `flatMapAsync` | Chain with FutureResult          |
| `recover`      | Provide fallback value on error  |
| `recoverWith`  | Provide fallback Result on error |
| `withTimeout`  | Add timeout to operation         |
| `inspect`      | Side effect on success           |
| `inspectErr`   | Side effect on error             |

### Recovery

```dart
FutureResult<User> getUser(String id) {
  return userRepository
      .findById(id)
      .recover((error) => User.guest());
}

FutureResult<User> getUserWithFallback(String id) {
  return userRepository
      .findById(id)
      .recoverWithAsync((error) => cacheRepository.findById(id));
}
```

## Unit Type

Use `Unit` instead of `void` for Result returns:

```dart
// Instead of Result<void>
FutureResult<Unit> deleteUser(String id) async {
  await firestore.collection('users').doc(id).delete();
  return ok; // shorthand for Ok(unit)
}
```

## Maintenance and Refactoring

When modifying or refactoring legacy code to use Option/Result:

### 1. Identify the Pattern
- **Nullable Returns:** If a function returns `T?`, refactor it to return `Option<T>` if the absence is expected (e.g., `findUser`), or `Result<T>` if the absence implies failure (e.g., `getRequiredConfig`).
- **Void Functions:** If a function is `void` or `Future<void>` but can fail, refactor it to return `Result<Unit>` or `FutureResult<Unit>`.
- **Try-Catch Blocks:** Replace try-catch blocks with `Result` chains using `map`, `flatMap`, and `recover`.

### 2. Refactoring Strategy
Start from the "leaves" of the call tree (e.g., repositories or utility functions) and work your way up.
1.  **Change the leaf function** to return `Option` or `Result`.
2.  **Update immediate callers** to handle the new type using `map`, `flatMap`, or pattern matching.
3.  **Propagate the change** up the stack until you reach a boundary (like a UI controller) where the result must be unwrapped or handled explicitly.

### 3. Boundary Handling
At the edges of your domain (e.g., API endpoints, UI widgets):
- **Unwrap safely:** Use `switch` statements to handle both `Some/None` or `Ok/Err` cases explicitly.
- **Avoid forced unwrapping:** Do not use `.unwrap()` unless you are absolutely certain (e.g., inside a test assertion) that failure is impossible.

## Best Practices (Result)

| Practice                                 | Description                   |
| ---------------------------------------- | ----------------------------- |
| Use `FutureResult<T>` in repositories    | Explicit async error handling |
| Return `FutureResult<Unit>` for void ops | Use `ok` shorthand            |
| Prefer `map`/`flatMap` over unwrap       | Safer transformations         |
| Include `StackTrace` in Err              | Better debugging              |
| Pattern match with switch                | Exhaustive handling           |
| Use `recover` for fallbacks              | Clean error recovery          |

## Anti-Patterns (Result)

### ❌ Using try-catch in calling code

```dart
// BAD: Defeats the purpose of Result
try {
  final user = await userRepository.findById(id).unwrap();
} catch (e) {
  // ...
}

// GOOD: Pattern match
final result = await userRepository.findById(id);
switch (result) {
  case Ok(value: final user): handleUser(user);
  case Err(value: final error): handleError(error);
}
```

### ❌ Ignoring errors

```dart
// BAD: Silent failure
final user = await userRepository.findById(id).unwrapOr(User.empty());

// GOOD: Explicit handling or logging
final result = await userRepository.findById(id);
final user = result.unwrapOrElse((error) {
  logger.error('Failed to fetch user', error);
  return User.empty();
});
```

### ❌ Throwing inside Result chain

```dart
// BAD: Throws break the chain
result.map((user) {
  if (user.isInvalid) throw Exception('Invalid');
  return user.name;
});

// GOOD: Return Err
result.flatMap((user) {
  if (user.isInvalid) return Err(Exception('Invalid'));
  return Ok(user.name);
});
```

### ❌ Nested Results

```dart
// BAD: Result<Result<T>>
Result<Result<User>> nested = Ok(Ok(user));

// GOOD: Use flatMap
Result<User> flat = result.flatMap((id) => findUser(id));
```

## Collection Utilities

### Wait for all results

```dart
final results = await FutureResultList.waitAll([
  fetchUser('1'),
  fetchUser('2'),
]);
// Returns List<Result<User>>
```

### All must succeed

```dart
final result = await FutureResultList.waitAllOrError([
  fetchUser('1'),
  fetchUser('2'),
]);
// Returns Result<List<User>> - Err if any fails
```

### First success

```dart
final result = await FutureResultList.any([
  primaryRepository.find(id),
  fallbackRepository.find(id),
]);
// Returns first Ok, or Err if all fail
```

## Option + Result Integration

Convert between types at appropriate boundaries:

```dart
// Option to Result (when absence is an error)
FutureResult<User> getRequiredUser(String id) {
  return userRepository
      .findById(id)
      .okOr(NotFoundException('User $id required'));
}

// Result to Option (when error should be ignored)
FutureOption<User> tryGetUser(String id) {
  return userRepository
      .fetchFromNetwork(id)  // Returns FutureResult
      .toOption();           // Err becomes None
}
```
