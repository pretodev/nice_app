---
trigger: model_decision
description: When the user asks to create, modify, or review code that handles errors, returns from repositories, async operations with error handling, or any code that should use Result/FutureResult pattern instead of try-catch.
---

Result is a sealed class for type-safe error handling. It replaces try-catch with explicit `Ok` and `Err` types, making error handling predictable and composable.

## Core Types

| Type              | Purpose                                        |
| ----------------- | ---------------------------------------------- |
| `Result<T>`       | Wrapper for success (`Ok`) or failure (`Err`)  |
| `Ok<T>`           | Contains success value                         |
| `Err<T>`          | Contains `Exception` and optional `StackTrace` |
| `FutureResult<T>` | Alias for `Future<Result<T>>`                  |
| `Unit`            | Replacement for `void` in Result returns       |
| `unit`            | Singleton instance of `Unit`                   |
| `ok`              | Shorthand for `Ok(unit)`                       |

## When to Use

- Repository methods returning data or errors
- Async operations that can fail
- Any function where caller needs to handle success/failure
- Replacing try-catch with explicit error handling

## Basic Usage

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

### Pattern Matching

```dart
switch (result) {
  case Ok(value: final user):
    print(user.name);
  case Err(value: final error):
    print(error);
}
```

### Unwrapping

```dart
// Throws if Err
final user = result.unwrap();

// Returns default if Err
final user = result.unwrapOr(User.empty());

// Computes value if Err
final user = result.unwrapOrElse((error) => User.guest());
```

## Transformations

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

### Repository Pattern

```dart
abstract class UserRepository {
  FutureResult<User> findById(String id);
  FutureResult<Unit> save(User user);
  FutureResult<List<User>> findAll();
}
```

### Implementation

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

### Chaining Async Operations

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

### Async Extensions

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

## Best Practices

| Practice                                 | Description                   |
| ---------------------------------------- | ----------------------------- |
| Use `FutureResult<T>` in repositories    | Explicit async error handling |
| Return `FutureResult<Unit>` for void ops | Use `ok` shorthand            |
| Prefer `map`/`flatMap` over unwrap       | Safer transformations         |
| Include `StackTrace` in Err              | Better debugging              |
| Pattern match with switch                | Exhaustive handling           |
| Use `recover` for fallbacks              | Clean error recovery          |

## Anti-Patterns

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
