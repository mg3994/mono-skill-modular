# BlogStore Monorepo Workspace

A modular Dart/Flutter monorepo organized into decoupled packages (`packages/`) and applications (`apps/`). The architecture is structured with pure Dart business logic and persistence, making it ready for cross-platform rendering using Flutter or DartNative.

## Workspace Overview

```
.
├── apps/
│   └── blogstore/          # Primary application using infrastructure and l10n
├── packages/
│   ├── infrastructure/     # Pure Dart persistence with Drift SQLite ORM
│   └── l10n/               # Pure Dart localization resources (ARB & generated AppLocalizations)
└── tools/                  # Workspace code generator extensions & Web Worker tools
```

## Prerequisites

1. Install the Flutter or Dart SDK:
   ```bash
   dart --version
   ```

2. Fetch dependencies across the workspace:
   ```bash
   flutter pub get
   ```

## Code Generation (`build_runner`)

This workspace uses `build_runner` for workspace-wide code generation (Drift database models, WASM workers, localizations). Run code generation from the workspace root:

```bash
dart run build_runner build --workspace
```

To clean stale generated files and rebuild:

```bash
dart run build_runner clean
dart run build_runner build --workspace
```

## Running Tests

Run tests across all workspace packages:

```bash
(cd packages/infrastructure && flutter test)
(cd packages/l10n && flutter test)
(cd apps/blogstore && flutter test)
```

## Architecture & DartNative Compatibility

- **`packages/infrastructure`**: Provides persistent state using Drift. Keeps database logic pure Dart (`sqlite3` FFI / `NativeDatabase`), which works with both Flutter and DartNative.
- **`packages/l10n`**: Manages ARB files and generates strongly typed `AppLocalizations`. Fully decoupled from rendering engines.
- **`apps/blogstore`**: Application shell bootstrapping database and localization delegates.
