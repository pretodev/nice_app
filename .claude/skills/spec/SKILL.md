---
name: creating-feature-spec
description: Creates feature specification documents for implementation planning. Use when user provides a feature definition in the format "Definição da feature [name]" followed by the feature description. Analyzes the codebase and generates a structured spec document in specs/ directory.
---

# Feature Specification Creator

Creates structured specification documents for new features based on the project's architecture patterns.

## Trigger

Activate when user provides a feature definition:
```
Definição da feature [Nome da Feature]

<Definição da feature>
```

## Workflow

Copy this checklist and track progress:

```
Spec Creation Progress:
- [ ] Step 1: Analyze feature definition
- [ ] Step 2: Explore codebase for patterns and shared resources
- [ ] Step 3: Answer architecture questions
- [ ] Step 4: Create specification document
- [ ] Step 5: Review and validate spec
```

### Step 1: Analyze Feature Definition

Extract from the user's definition:
- Feature name and purpose
- Core functionality described
- Implicit requirements and constraints

### Step 2: Explore Codebase

Use the Explore agent to:
1. Check `lib/shared/` for reusable utilities (CommandMixin, Firestore base classes, extensions)
2. Review existing features in `lib/features/` for similar patterns
3. Identify existing domain models that may relate to the new feature

### Step 3: Answer Architecture Questions

Analyze the feature to answer:

1. **Visual Components**: Buttons, inputs, error messages, loading states?
2. **User Flows**: What are the step-by-step user interactions?
3. **Backend Interactions**: Firestore operations, API calls, external services?
4. **Business Rules**: Validations, constraints, calculations?
5. **Security Constraints**: Authentication, authorization, data validation?
6. **Feature Dependencies**: Which existing features does this depend on?
7. **Architecture Components**:
   - Repository needed? (data persistence)
   - Commands needed? (business logic operations)
   - Queries needed? (reactive data streams)
8. **Aggregate Root**: Is there a central entity? What is it?

### Step 4: Create Specification Document

Create file at: `specs/YYYYMMDD-feature-slug.md`

Example: `specs/20260130-login-usuario.md`

Use the template in [SPEC_TEMPLATE.md](SPEC_TEMPLATE.md).

### Step 5: Review and Validate

Verify the spec:
- All architecture questions answered
- Consistent with project patterns
- Clear separation of concerns
- No missing dependencies identified

## Architecture Reference

See [ARCHITECTURE.md](ARCHITECTURE.md) for project patterns.

## Output

After creating the spec, inform the user:
1. Spec file location
2. Summary of identified components
3. Any assumptions or questions for clarification
