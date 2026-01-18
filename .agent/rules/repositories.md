---
trigger: model_decision
description: When working with data layer, persistence and Repositories.
---

# Repository Guidelines

## Overview

A repository is a component of the data layer that serves as a data persistence layer. It abstracts data persistence without containing any business rules.

## Core Principles

### Single Responsibility

- A repository is directly linked to an entity (AggregateRoot)
- There should be **only one repository per feature/module**
- A repository can combine multiple data sources into a single unified interface

### No Business Logic

- Repositories must **not** contain any business rules
- They only handle data persistence and retrieval operations
- Business logic belongs in the entity or domain services

## Method Naming Conventions

### Store Operations

Use `store(Entity)` method for both creating and updating entities:

```
repository.store(entity)
```

### Search Operations

Use the `find` verb for all search/query operations:

```
repository.findById(id)
repository.findByEmail(email)
repository.findAll()
```

### Delete Operations

Use the `delete()` method, which will **deactivate** the entity (soft delete):

```
repository.delete(entity)
```

## Anti-Patterns

### ❌ Avoid Field-Specific Update Methods

Do **not** create methods like:

- `updateName()`
- `setField()`
- `updateEmail()`
- Any other field-specific setters

### ✅ Correct Approach

1. Modify the entity using its business methods
2. Pass the modified entity to the repository's `store()` method for persistence

Example:

```
// ❌ Wrong
repository.updateName(entity, newName)

// ✅ Correct
entity.changeName(newName)  // Business method on entity
repository.store(entity)     // Persist via repository
```

## Summary

- One repository per feature/module
- Linked to an AggregateRoot entity
- Can combine multiple data sources
- Use `store()` for create/update operations
- Use `find*()` for queries
- Use `delete()` for soft deletion
- Modify entities through their business methods, then persist with `store()`
