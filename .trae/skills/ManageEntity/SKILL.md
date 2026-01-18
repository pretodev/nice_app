---
name: ManageEntity
description: Guidelines for creating, maintaining, and modifying domain entities in the odu_core project.
---

Guidelines for managing domain entities in odu_core. These rules apply to both AI assistants and developers for creating new entities and maintaining existing ones.

## Identity Type Selection

Choose the appropriate base class for your entity:

| Base Class     | ID Type         | Use When                                                                   |
| -------------- | --------------- | -------------------------------------------------------------------------- |
| `GuidEntity`   | `String` (UUID) | IDs are generated client-side, distributed systems, offline-first apps     |
| `SerialEntity` | `int`           | IDs come from database auto-increment, centralized persistence             |
| `Entity<T>`    | Custom `T`      | Domain requires specific ID format (e.g., `Email`, `Slug`, composite keys) |

**Key differences:**

- **GuidEntity**: Use `GuidEntity.newId()` to generate UUID v4 in creation factories
- **SerialEntity**: Use `SerialEntity.unsavedId` (0) for new entities; provides `isPersisted`/`isNew` getters
- **Entity<T>**: For custom ID types; create Value Objects for the ID type

For custom identity types, create a Value Object for the ID and extend `Entity<YourIdType>`.

## Required Structure

### 1. Public Constructor

All entities MUST have a public constructor that receives all fields:

```dart
class Order extends GuidEntity {
  final String customerId;
  final List<OrderItem> _items;
  OrderStatus _status;

  Order({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
    required this.customerId,
    required List<OrderItem> items,
    required OrderStatus status,
  }) : _items = items.toList(),
       _status = status;
}
```

**Why public constructor with all fields?**

- Enables reconstituting entities from persistence without needing a separate factory
- All fields must be provided (via required parameters or defaults)
- Validation is enforced via `validate()` hook called by Entity base class

### 2. Creation Factory

Entities SHOULD have factory methods for common creation scenarios:

**For GuidEntity:**

```dart
factory Order.create({required String customerId}) {
  final now = DateTime.now();
  return Order(
    id: GuidEntity.newId(),
    createdAt: now,
    updatedAt: now,
    isActive: true,
    customerId: customerId,
    items: [],
    status: OrderStatus.draft,
  );
}
```

**For SerialEntity:**

```dart
factory Product.create({required String name}) {
  final now = DateTime.now();
  return Product(
    id: SerialEntity.unsavedId,  // 0 for new entities
    createdAt: now,
    updatedAt: now,
    isActive: true,
    name: name,
  );
}
```

**Best practices:**

- Name the primary factory `.create()` for consistency
- Set `isActive: true` by default for new entities
- Initialize `createdAt` and `updatedAt` to the same value (no change on creation)
- Factories are optional since the public constructor can be used directly for persistence

### 3. Multiple Creation Factories (Optional)

When entities have multiple valid creation paths, use named factories:

```dart
factory Order.create({required String customerId}) {
  final now = DateTime.now();
  return Order(
    id: GuidEntity.newId(),
    createdAt: now,
    updatedAt: now,
    isActive: true,
    customerId: customerId,
    items: [],
    status: OrderStatus.draft,
  );
}

factory Order.withItems({
  required String customerId,
  required List<OrderItem> items,
}) {
  final now = DateTime.now();
  return Order(
    id: GuidEntity.newId(),
    createdAt: now,
    updatedAt: now,
    isActive: true,
    customerId: customerId,
    items: items,
    status: OrderStatus.draft,
  );
}
```

**Naming conventions:**

- Use descriptive names that indicate the creation path
- Primary factory should be `.create()`
- Consider `.withX()` for variations with additional data

## Encapsulation Rules

### Protect Internal Collections

NEVER expose mutable collections directly. Return unmodifiable views:

```dart
// BAD: Exposes internal mutable state
class Order {
  final List<OrderItem> _items;
  List<OrderItem> get items => _items;  // External code can call .add()!
}

// GOOD: Return unmodifiable view
class Order {
  final List<OrderItem> _items;
  List<OrderItem> get items => List.unmodifiable(_items);
}
```

### Use Domain Methods for State Changes

Entities SHOULD expose behavior through methods that modify state:

```dart
// BAD: Anemic model with public mutable data
class Order {
  List<OrderItem> items = [];
  OrderStatus status = OrderStatus.draft;
}

// GOOD: Rich domain model with behavior
class Order {
  final List<OrderItem> _items;
  OrderStatus _status;

  // Domain methods modify internal state
  void addItem(OrderItem item) {
    if (_status != OrderStatus.draft) {
      throw OrderFailure('Cannot add items to non-draft order');
    }
    _items.add(item);
    updatedAt = DateTime.now();
  }

  void removeItem(String itemId) {
    if (_status != OrderStatus.draft) {
      throw OrderFailure('Cannot remove items from non-draft order');
    }
    _items.removeWhere((i) => i.id == itemId);
    updatedAt = DateTime.now();
  }

  void submit() {
    if (!canBeSubmitted) {
      throw OrderFailure('Order cannot be submitted');
    }
    _status = OrderStatus.submitted;
    updatedAt = DateTime.now();
  }
}
```

**Key principles:**

- Domain methods should mutate entity state directly (entities are mutable)
- Always update `updatedAt` when state changes
- Enforce business rules before allowing state changes
- Use private fields with controlled access through methods

## Validation

### Enforce Invariants via validate()

Override `validate()` to enforce business rules. This is called automatically by the Entity constructor:

```dart
@override
void validate() {
  if (customerId.isEmpty) {
    throw OrderFailure('Customer ID cannot be empty');
  }
  if (_items.isEmpty && status == OrderStatus.submitted) {
    throw OrderFailure('Submitted order must have at least one item');
  }
}
```

**Best practices:**

- Validate invariants that MUST always be true
- Throw specific failure types (extend `EntityFailure`)
- Keep validation pure (no side effects)
- Don't validate business rules that are contextual (use domain methods instead)

### Create Specific Failure Types

Each aggregate root SHOULD define its own failure class:

```dart
class OrderFailure extends EntityFailure {
  OrderFailure(super.message);
}
```

**Why specific failures?**

- Enables type-safe error handling
- Makes domain errors explicit and discoverable
- Aligns with Result type error handling patterns

## Props for Debugging

Override `props` to include domain-specific properties in `toString()`:

```dart
@override
List<Object?> get props => [customerId, 'items: ${_items.length}'];
```

Note: `props` is for debugging only and does NOT affect equality. Entities are equal by ID.

## Documentation Guidelines

Document only what is necessary:

- **DO** document non-obvious business rules in `validate()`
- **DO** document factory methods when creation involves complex logic
- **DO** document side effects or constraints on domain methods
- **DON'T** document obvious getters, constructors, or standard patterns
- **DON'T** add redundant `@override` documentation

## Maintenance and Modification

When modifying existing entities:

1.  **Preserve Invariants**: Ensure new changes do not violate existing validation rules in `validate()`.
2.  **Add Validation**: If adding new fields that have constraints, update `validate()` to include checks for them.
3.  **Update Factories**: If adding required fields, update all creation factories (`.create()`, etc.) to initialize them.
4.  **Audit State Changes**: When adding new domain methods, ensure they update `updatedAt`.
5.  **Backward Compatibility**: Be mindful of how changes affect existing persisted data (e.g., adding a non-nullable field without a default value).

## Best Practices

1. **Keep entities focused**: One aggregate root per bounded context concern
2. **Prefer composition**: Use Value Objects for complex attributes
3. **Make illegal states unrepresentable**: Use types and validation to prevent invalid states
4. **Update timestamps explicitly**: Always set `updatedAt = DateTime.now()` when modifying entity state
5. **Use `SerialEntity.unsavedId`**: For new serial entities not yet persisted (value is 0)
6. **Use `GuidEntity.newId()`**: For generating new UUIDs in creation factories
7. **Protect collections**: Return unmodifiable views from getters to prevent external mutation
8. **Use domain methods**: Expose behavior through methods, not direct property access
9. **Validate consistently**: Use `validate()` for invariants, domain methods for contextual rules
10. **Entities are mutable**: Change state directly in domain methods; no need for `copyWith`

## Code Smells to Avoid

| Smell                           | Problem                                    | Solution                                    |
| ------------------------------- | ------------------------------------------ | ------------------------------------------- |
| Public setters                  | Breaks encapsulation, allows invalid state | Use domain methods that enforce rules       |
| Public mutable collections      | External code can corrupt internal state   | Return unmodifiable views from getters      |
| Empty `validate()`              | Invariants not enforced                    | Add business rule validation                |
| Logic in getters                | Hidden side effects, hard to test          | Extract to explicit methods                 |
| Entity without behavior         | Anemic domain model                        | Add domain methods that modify state        |
| Setters for computed properties | Inconsistent state                         | Make computed props read-only getters       |
| Inheritance for code reuse      | Tight coupling                             | Use composition with Value Objects          |
| ID as primitive in domain logic | Primitive obsession                        | Create ID Value Objects when needed         |
| Using `copyWith` in entities    | Treats entities as immutable               | Mutate state directly in domain methods     |
| Not updating `updatedAt`        | Breaks audit trail                         | Set `updatedAt = DateTime.now()` on changes |
| Private constructor only        | Can't reconstitute from database           | Use public constructor for all fields       |
