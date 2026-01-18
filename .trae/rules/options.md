---
trigger: model_decision
description: When the user asks to create, modify, or review code that handles nullable values, optional data, queries that may return nothing, or any code that should use Option/FutureOption pattern instead of null.
---

Option is a sealed class for type-safe handling of values that may or may not exist. It replaces nullable types with explicit `Some` and `None`, making absence handling predictable and composable.

## Core Types

| Type              | Purpose                                               |
| ----------------- | ----------------------------------------------------- |
| `Option<T>`       | Wrapper for present (`Some`) or absent (`None`) value |
| `Some<T>`         | Contains a value                                      |
| `None<T>`         | Represents absence of value                           |
| `FutureOption<T>` | Alias for `Future<Option<T>>`                         |

## When to Use

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

## Basic Usage

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

## Transformations

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

## Factory Methods

```dart
// Create Some
final option = await FutureOptionFactory.some(user);

// Create None
final option = await FutureOptionFactory.none<User>();

// From nullable Future
final option = await FutureOptionFactory.from(nullableFuture);
```

## Best Practices

| Practice                                  | Description                     |
| ----------------------------------------- | ------------------------------- |
| Use for queries that may return nothing   | `findById`, `findByEmail`, etc. |
| Use `Result` for operations that can fail | Network, IO, validation         |
| Prefer `map`/`flatMap` over unwrap        | Safer transformations           |
| Convert to `Result` at boundaries         | When absence becomes an error   |
| Use `filter` for conditional logic        | Cleaner than nested ifs         |

## Anti-Patterns

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
