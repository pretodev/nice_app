---
trigger: always_on
---
1. Static Analysis & Quality Control
- **Mandatory Analysis:** After generating or modifying any code, you must strictly run the Dart analyzer to ensure no regressions were introduced.
- **Fixing Issues:**
  - Prioritize using `dart fix --apply` to resolve linter warnings and errors automatically.
  - If manual intervention is required, fix the errors yourself.
  - **Zero Tolerance for Deprecation:** Ensure no deprecated classes, methods, or fields are used. Replace them with their modern equivalents.

2. Formatting: Apply standard formatting using `dart format` **only** to the files you created or modified. Do not format the entire project.

3. Code Generation
- Check if the modified files rely on code generation (e.g., usage of `@freezed`, `@JsonSerializable`, `@Riverpod`, etc.).
- If code generation is required, you must run `dart run build_runner build -d`

4. Constraints & Prohibitions
- **No Runtime Execution:** NEVER attempt to compile the app (`flutter build`) or run the app (`flutter run`). Your scope ends at code delivery and static verification.
- **No Testing:** Do NOT implement unit tests or widget tests unless explicitly asked. Focus solely on the implementation logic.

5. Summary Checklist for Every Delivery

1.  Generate/Refactor Code.
2.  Run `dart format <file>`.
3.  Run `flutter analyze`.
4.  Run `dart fix` or manually fix errors/deprecations.
5.  Run `dart run build_runner build -d` (if applicable).
