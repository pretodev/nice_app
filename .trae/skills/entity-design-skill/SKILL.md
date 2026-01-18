---
name: Entity Design Skill
description: "Create and modify domain entities following DDD principles with proper encapsulation, validation, and identity management.

- Creating new domain entities
- Modifying existing entities
- Adding business methods to entities
- Refactoring anemic models to rich domain models
- Implementing entity validation"
---

1. **Choose the correct identity type:**
   - `GuidEntity` for client-side generated UUIDs
   - `SerialEntity` for database auto-increment IDs
   - `Entity<T>` for custom ID types

2. **Create public constructor** with all required fields including:
   - `id`, `createdAt`, `updatedAt`, `isActive`
   - All domain-specific fields

3. **Add creation factory** (e.g., `.create()`) that:
   - Generates appropriate ID using `GuidEntity.newId()` or `SerialEntity.unsavedId`
   - Sets `createdAt` and `updatedAt` to current time
   - Sets `isActive: true` by default
   - Initializes entity in valid state

4. **Protect internal collections:**
   - Use private fields with underscore prefix
   - Return `List.unmodifiable()` from getters
   - Never expose mutable collections directly

5. **Implement domain methods** for state changes:
   - Mutate entity state directly (entities are mutable)
   - Always update `updatedAt = DateTime.now()` when changing state
   - Enforce business rules before allowing changes
   - Throw specific failure types (extend `EntityFailure`)

6. **Override `validate()`** to enforce invariants:
   - Check required fields
   - Validate business rules that must always be true
   - Throw specific `EntityFailure` subclass with clear messages

7. **Create specific failure class** extending `EntityFailure`

8. **Override `props`** for debugging (include key domain properties)

## Key principles

- Entities are mutable - change state directly in domain methods
- Always update `updatedAt` when modifying state
- Use public constructor for all fields (enables reconstitution from persistence)
- Validate via `validate()` hook (called automatically by Entity base class)
- Make illegal states unrepresentable through types and validation
- Prefer composition with Value Objects over complex attributes
- Keep entities focused on single aggregate root per bounded context

## Anti-patterns to avoid

- Public setters (breaks encapsulation)
- Public mutable collections (allows external corruption)
- Empty `validate()` (invariants not enforced)
- Logic in getters (hidden side effects)
- Anemic entities without behavior
- Using `copyWith` (treat entities as mutable, not immutable)
- Not updating `updatedAt` on changes
- Private-only constructors (can't reconstitute from database)

## Example structure

```dart
class Order extends GuidEntity {
  final String customerId;
  final List<OrderItem> _items;
  OrderStatus _status;

  // Public constructor with all fields
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

  // Creation factory
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

  // Protected collection with unmodifiable view
  List<OrderItem> get items => List.unmodifiable(_items);

  // Domain methods that enforce rules
  void addItem(OrderItem item) {
    if (_status != OrderStatus.draft) {
      throw OrderFailure('Cannot add items to non-draft order');
    }
    _items.add(item);
    updatedAt = DateTime.now();
  }

  void submit() {
    if (!canBeSubmitted) {
      throw OrderFailure('Order cannot be submitted');
    }
    _status = OrderStatus.submitted;
    updatedAt = DateTime.now();
  }

  @override
  void validate() {
    if (customerId.isEmpty) {
      throw OrderFailure('Customer ID cannot be empty');
    }
  }

  @override
  List<Object?> get props => [customerId, 'items: ${_items.length}'];
}

class OrderFailure extends EntityFailure {
  OrderFailure(super.message);
}
```