---
name: drift-app-database-testing
description: "Use when writing or reviewing tests for a Drift AppDatabase, including in-memory QueryExecutor tests, schema-version checks, SQL connectivity checks, teardown, migration tests, and keeping feature-table tests separate from database bootstrap tests."
---

# Drift AppDatabase Testing

Use this skill for tests that prove the database infrastructure works without coupling those tests to a feature table that may later move to another package.

## Testing Boundary

`AppDatabase` tests should validate database infrastructure:

- construction with an injected executor
- schema version
- opening and closing the database
- executing a basic SQL statement
- migration behavior when migrations exist

Feature-table tests should live with the feature or table owner. For example, tests for `AppearanceSettings` defaults, consent behavior, or row updates should not be placed in the AppDatabase bootstrap test once that table is moved.

This separation keeps a table migration from forcing unrelated database infrastructure tests to change.

## Test Dependencies

The infrastructure package needs Flutter's test framework and the native Drift executor available to the test target. In a Flutter workspace, the test normally imports:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/database/drift/app_database.dart';
```

If the package's dependency graph does not expose `drift` APIs directly to tests, add the direct dependency required by the package's Dart analyzer rather than relying on an accidental transitive import.

## Standard Isolated Test Fixture

Use one in-memory database per test:

```dart
void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  // tests
}
```

Why this pattern matters:

- `NativeDatabase.memory()` avoids the real application support directory.
- Each test starts with a clean database.
- Closing the database prevents open handles and file-lock warnings.
- The production executor configuration is not exercised accidentally by unit tests.

Do not share one mutable database instance across tests unless the test explicitly validates a multi-step transaction or migration lifecycle.

## AppDatabase-Only Test Examples

The current infrastructure-level test file can remain small:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/database/drift/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('AppDatabase', () {
    test('uses schema version 1', () {
      expect(database.schemaVersion, 1);
    });

    test('opens an executable database connection', () async {
      final result = await database
          .customSelect('SELECT 1 AS value')
          .getSingle();

      expect(result.data['value'], 1);
    });
  });
}
```

Update the expected schema version when the intentional database version changes. Do not use this test to assert columns or defaults belonging to `AppearanceSettings` or another feature table.

## Feature Table Test Location

When a table is still temporarily declared inside `AppDatabase`, it is acceptable to create a separate test file for that table, for example:

```text
test/appearance_settings_test.dart
```

That file may test:

- insert defaults
- primary-key behavior
- updates
- feature-specific queries

It should still use the same injected in-memory database fixture. Keeping the file separate makes the future extraction of `AppearanceSettings` mechanical.

Avoid importing generated classes in tests when the source declaration exposes the needed public API. Generated names are implementation details and can change after Drift upgrades or table moves.

## Migration Tests

A schema-version test is not a migration test. When migrations are introduced, cover both the version and the data transition.

Recommended migration test shape:

1. Create a database at the old schema version using a controlled executor.
2. Insert representative old-format data.
3. Reopen or migrate using the current `AppDatabase` migration strategy.
4. Assert the old data is still represented correctly.
5. Assert new columns or indexes exist when relevant.

Migration tests should focus on data preservation and compatibility, not generated class internals.

## Commands

From the infrastructure package:

```powershell
flutter test test/database_test.dart
```

Run all package tests with:

```powershell
flutter test
```

If generated Drift code is stale, regenerate first:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Then rerun the focused test before the full package suite.

## Common Failures

### Test file cannot be found

The command is relative to the current directory. If the shell is at the workspace root, either change into `packages/infrastructure` or pass the package-relative path:

```powershell
Set-Location packages/infrastructure
flutter test test/database_test.dart
```

### Empty placeholder test fails to load

Every file under `test/` is discovered as a test file. An empty Dart file without `main()` fails to compile. Delete the placeholder or give it a real test entrypoint.

### Database uses the real filesystem during tests

The test probably called `AppDatabase()` instead of injecting `NativeDatabase.memory()`. Use the injected executor fixture.

### Generated symbol is missing

Run Drift generation from the package that owns `build.yaml`, then check that `app_database.g.dart` is present beside `app_database.dart`.

### Web test fails because the worker is missing

The in-memory native test does not validate the web worker. Use the `drift-web-worker-build` skill to generate `apps/blogstore/web/drift_worker.js`, then run the appropriate web test target.

## Review Checklist

When reviewing AppDatabase tests, check:

- Does each test get a fresh in-memory executor?
- Is `close()` awaited in teardown?
- Are tests asserting database infrastructure rather than a table's feature policy?
- Is the schema version expectation intentional?
- Is SQL kept minimal and portable?
- Are migrations tested separately from simple construction?
- Would the test still make sense after `AppearanceSettings` moves out?
