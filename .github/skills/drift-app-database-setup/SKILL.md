---
name: drift-app-database-setup
description: "Use when adding or configuring a Drift AppDatabase in a Flutter workspace, including drift_flutter, path_provider, drift_dev, package-local build.yaml, generated database code, native storage, web worker paths, or schema versioning. Keep domain-specific tables such as AppearanceSettings separate from the database bootstrap design."
---

# Drift AppDatabase Setup

Use this skill when setting up the infrastructure package that owns the application's Drift database. The goal is to make `AppDatabase` a stable storage boundary while allowing individual feature tables to move into their own packages later.

## Repository Shape

This workspace currently uses:

- Infrastructure package: `packages/infrastructure`
- Database source: `packages/infrastructure/lib/src/database/drift/app_database.dart`
- Generated Drift source: `app_database.g.dart`
- Package-local build configuration: `packages/infrastructure/build.yaml`
- Flutter application: `apps/blogstore`
- Web worker asset: `apps/blogstore/web/drift_worker.js`

The database class currently accepts an optional `QueryExecutor`. Preserve that injection point. It makes production configuration simple while allowing tests to use `NativeDatabase.memory()`.

## Dependency Roles

Add the runtime packages to the infrastructure package's `dependencies`:

```yaml
dependencies:
  drift_flutter: ^0.3.1
  path_provider: ^2.1.6
```

Add the generator to `dev_dependencies`:

```yaml
dev_dependencies:
  drift_dev: ^2.34.6
```

The roles are intentionally separate:

- `drift_flutter` provides Flutter-aware database configuration and the web/native executor setup.
- `path_provider` supplies the application support directory used by native database storage.
- `drift_dev` generates table data classes, companions, database managers, and schema metadata.
- `drift` is normally available transitively through `drift_flutter`; add it directly only when source code or workspace tooling requires a direct dependency.

Run dependency resolution from the workspace root or the infrastructure package, following the workspace's package manager conventions:

```powershell
flutter pub get
```

## AppDatabase Bootstrap

A minimal database bootstrap has four responsibilities:

1. Import Drift and Flutter's Drift integration.
2. Declare the generated part file.
3. Configure a production executor for native and web platforms.
4. expose a schema version.

Use this shape:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;

part 'app_database.g.dart';

@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(
          executor ??
              driftDatabase(
                name: 'blogstore',
                native: const DriftNativeOptions(
                  databaseDirectory: getApplicationSupportDirectory,
                ),
                web: DriftWebOptions(
                  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                  driftWorker: Uri.parse('drift_worker.js'),
                ),
              ),
        );

  @override
  int get schemaVersion => 1;
}
```

The exact `@DriftDatabase` table list may be temporarily non-empty while tables are being migrated. The bootstrap class should remain responsible for wiring and lifecycle, not for owning feature policy.

### Constructor Contract

Keep the optional executor parameter:

```dart
AppDatabase([QueryExecutor? executor])
```

Production code calls `AppDatabase()` and receives the configured `driftDatabase` executor. Tests call `AppDatabase(NativeDatabase.memory())` and avoid touching the device filesystem, platform channels, or web worker assets.

Do not create a second production constructor for tests. The injected executor is the narrow, Drift-native seam needed for isolation.

### Native Storage

`DriftNativeOptions.databaseDirectory` should point to `getApplicationSupportDirectory`. Drift chooses the database file name from `name: 'blogstore'`.

Keep the database name stable after release. Changing it silently creates a new database and can look like data loss. If a rename is required, treat it as a migration and document the transfer plan.

### Web Storage

The web options refer to assets that must be available to the Flutter web application:

```dart
web: DriftWebOptions(
  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
  driftWorker: Uri.parse('drift_worker.js'),
),
```

`drift_worker.js` is produced by the workspace's web-worker build workflow. Use the `drift-web-worker-build` skill for compiling and copying it. Do not hand-edit generated worker output.

## Package-Local build.yaml

For `packages/infrastructure/build.yaml`, use a package-local Drift target:

```yaml
targets:
  $default:
    sources:
      - lib/**
      - pubspec.yaml
      - lib/$lib$
      - $package$

    builders:
      drift_dev:
        options:
          databases:
            default: lib/src/database/drift/app_database.dart

          sql:
            dialect: sqlite
            options:
              version: "3.38"
              modules:
                - fts5
```

What matters:

- `sources` includes the database Dart source and package metadata.
- `drift_dev` is enabled for the default package target.
- `databases.default` points to the Dart file containing `AppDatabase`.
- The database path is package-relative, not workspace-root-relative.
- SQLite is the selected SQL dialect.
- The SQL version and optional modules must match the SQLite features the application intends to use.

Do not put the infrastructure database path in the workspace root `build.yaml` unless the entire workspace build specifically needs to own that target. Keep package-owned generation close to the package that owns the database.

## Generation Commands

From `packages/infrastructure`:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

From the workspace root, use the workspace-aware command only when generation must cover multiple workspace packages:

```powershell
dart run build_runner build --workspace --delete-conflicting-outputs
```

Expected output includes a generated file beside the source:

```text
lib/src/database/drift/app_database.g.dart
```

Generated files are build products. Do not manually edit them. Change the source table or database declaration, then regenerate.

## Schema Versioning

Start at:

```dart
@override
int get schemaVersion => 1;
```

When changing an existing schema:

1. Increase the version by one.
2. Add a `MigrationStrategy` when data transformation or compatibility work is required.
3. Preserve existing data explicitly.
4. Regenerate Drift code.
5. Add a migration test that starts from the old schema when practical.
6. Run the database test suite on native and web targets when both are supported.

Do not increase `schemaVersion` for a source-only refactor that produces no SQL schema change.

## AppearanceSettings Boundary

`AppearanceSettings` is a domain-specific table currently colocated with `AppDatabase` for convenience. It is not the long-term database bootstrap abstraction.

For the current migration plan:

- Leave `AppearanceSettings` behavior unchanged unless the task explicitly concerns its migration.
- Do not copy its columns into a new generic settings table.
- Do not add appearance or consent assertions to tests that are intended to validate only `AppDatabase` construction.
- When the table moves, update the `@DriftDatabase` declaration, package ownership, generated output, and migration strategy together.
- Preserve the database name and schema version semantics while moving ownership.

The database setup skill should remain valid after `AppearanceSettings` is extracted. That is the reason the setup examples use an empty table list and treat feature tables as replaceable wiring.

## Checklist

Before considering setup complete:

- `drift_flutter` and `path_provider` are runtime dependencies.
- `drift_dev` is a development dependency.
- `AppDatabase` has an injected `QueryExecutor`.
- Native storage uses `getApplicationSupportDirectory`.
- Web options point to the actual WASM and worker asset paths.
- `build.yaml` points to the correct package-local database file.
- `schemaVersion` is explicit.
- `build_runner` generates `app_database.g.dart` without conflicts.
- The web worker is built through the dedicated worker workflow.
- `AppearanceSettings` has not been unintentionally redesigned as part of bootstrap setup.
