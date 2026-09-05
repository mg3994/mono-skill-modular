---
name: drift-web-worker-build
description: "Use when compiling Drift's WASM web worker with build_runner, copying drift_worker.dart.js into a Flutter app web directory, configuring build.yaml, or diagnosing missing generated web worker files in a Dart workspace."
---

# Drift Web Worker Build

Use this skill when a Flutter or Dart workspace needs Drift's WASM worker compiled to JavaScript and made visible inside an application's `web/` directory.

This skill documents the working arrangement in this repository:

- Workspace root: `c:/Users/manis/Desktop/workspace/workspace`
- Flutter application: `apps/blogstore`
- Worker source: `tools/drift_worker.dart`
- Custom copy builder: `tools/builder.dart`
- Generated application asset: `apps/blogstore/web/drift_worker.js`
- Build configuration: `build.yaml` at the workspace root

## What The Build Does

The build has two stages:

1. `build_web_compilers:entrypoint` compiles `tools/drift_worker.dart` with `dart2js`.
2. The local `copy_compiled_worker_js` builder reads the generated private asset `tools/drift_worker.dart.js` and writes it to `apps/blogstore/web/drift_worker.js`.

The compiler output is initially kept in build_runner's generated asset graph. Flutter will not automatically ship that private output from the build cache, so the second builder exposes a copy in the app's normal `web/` directory.

The final output is a JavaScript worker used by the Flutter web application. It is not a Dart source file and should not be hand-edited.

## Required Packages

The workspace root `pubspec.yaml` provides the packages needed by this build:

```yaml
dev_dependencies:
  build: ^4.0.7
  build_runner: ^2.15.1
  build_web_compilers: ^4.8.5
  drift: ^2.34.4
```

Their roles are:

- `drift`: provides `WasmDatabase.workerMainForOpen()` from `package:drift/wasm.dart`.
- `build`: provides the `Builder`, `BuildStep`, `BuilderOptions`, and `AssetId` APIs used by the custom copy builder.
- `build_runner`: executes the workspace build graph and custom builders.
- `build_web_compilers`: provides the `build_web_compilers:entrypoint` builder and invokes Dart's JavaScript compiler.

The Flutter application remains a workspace member through the root `pubspec.yaml` workspace declaration:

```yaml
workspace:
  - apps/**
  - packages/**
```

## Worker Entry Point

Create `tools/drift_worker.dart` with the Drift WASM worker entrypoint:

```dart
import 'package:drift/wasm.dart';

void main() {
  return WasmDatabase.workerMainForOpen();
}
```

The file must be inside a directory included by the root build target. In this repository that means the `tools/` directory is explicitly included with:

```yaml
sources:
  - "tools/**"
```

This directory declaration is required. The source path `tool/**` is different from `tools/**` and will not include `tools/drift_worker.dart`. If the directory is omitted or misspelled, the compiler builder has no matching primary input and the build can finish with zero outputs.

## Custom Copy Builder

Create `tools/builder.dart`:

```dart
import 'package:build/build.dart';

class CopyCompiledJs extends Builder {
  CopyCompiledJs([BuilderOptions? options]);

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final outputId = buildStep.allowedOutputs.single;
    final compiledId = AssetId(inputId.package, '${inputId.path}.js');

    final compiledWorker = await buildStep.readAsBytes(compiledId);
    await buildStep.writeAsBytes(outputId, compiledWorker);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    'tools/drift_worker.dart': ['apps/blogstore/web/drift_worker.js'],
  };
}
```

Important details:

- The builder's primary input is `tools/drift_worker.dart`, not `tools/drift_worker.dart.js`.
- `required_inputs: [.js]` makes build_runner order this builder after the JavaScript compiler.
- The generated compiler asset is read explicitly as `${inputId.path}.js`, which resolves to `tools/drift_worker.dart.js`.
- `allowedOutputs.single` is the destination declared by `build_extensions`.
- `build_to: source` is needed because the output must be visible in the Flutter app's checked-out `web/` directory.
- Do not use `readAsBytes(inputId)` here: that reads the Dart source instead of the compiled JavaScript.

## Root build.yaml

Use this configuration in the workspace root `build.yaml`:

```yaml
targets:
  $default:
    sources:
      - "apps/**"
      - "packages/**"
      - "tools/**"
      - pubspec.yaml
      - lib/$lib$
      - $package$
    builders:
      build_web_compilers:entrypoint:
        generate_for:
          - tools/drift_worker.dart
        options:
          compiler: dart2js
      ":copy_compiled_worker_js":
        enabled: true

builders:
  copy_compiled_worker_js:
    import: "tools/builder.dart"
    builder_factories: ["CopyCompiledJs.new"]
    required_inputs:
      - .js
    build_to: source
    build_extensions:
      "tools/drift_worker.dart": ["apps/blogstore/web/drift_worker.js"]
```

### Why Each Configuration Part Matters

- `targets.$default`: the normal target used by `dart run build_runner build --workspace`.
- `sources`: makes files under `tools/` available to the root package build. The exact `"tools/**"` entry is mandatory for this layout.
- `build_web_compilers:entrypoint`: selects the web compiler builder.
- `generate_for`: limits compilation to the worker entrypoint instead of compiling every Dart file.
- `compiler: dart2js`: produces browser-compatible JavaScript.
- `":copy_compiled_worker_js"`: enables the custom builder declared by the current package. The leading colon means the builder is local to the workspace root package.
- `required_inputs: [.js]`: expresses the ordering dependency on the compiler's generated JavaScript asset.
- `build_to: source`: makes the copied output visible under `apps/blogstore/web/`.
- `build_extensions`: maps the Dart primary input to the final JavaScript output path.

Do not put the copy builder only under a separate target such as `copy_js` when invoking the normal workspace command. The command builds `$default`; a builder enabled only in another target will not run, which can result in `wrote 0 outputs`.

## Build Command

Run this from the workspace root:

```powershell
dart run build_runner build --workspace --delete-conflicting-outputs
```

The `--workspace` option builds the root package and workspace packages according to the workspace configuration.

Expected compiler behavior includes a line similar to:

```text
workspace|tools/drift_worker.dart build_web_compilers:entrypoint
Running `dart compile js`
```

Expected copy-builder behavior includes a line similar to:

```text
workspace:copy_compiled_worker_js on 1 input: 1 output
```

The final file should exist at:

```text
apps/blogstore/web/drift_worker.js
```

A quick PowerShell check:

```powershell
Get-Item .\apps\blogstore\web\drift_worker.js |
  Select-Object FullName, Length, LastWriteTime
```

## Troubleshooting

### Build says `wrote 0 outputs`

Check these items in order:

1. Confirm the command includes `--workspace` and is run from the workspace root.
2. Confirm `tools/drift_worker.dart` exists.
3. Confirm `$default.sources` contains the exact entry `"tools/**"`.
4. Confirm `generate_for` uses `tools/drift_worker.dart`.
5. Confirm `":copy_compiled_worker_js"` is enabled under `$default.builders`.
6. Confirm the local builder is declared under the root `builders` section.
7. Run with `--verbose` and look for the `build_web_compilers:entrypoint` line.

### Compiler runs but the app file is missing

The compiler output is private if only `build_web_compilers:entrypoint` is enabled. Confirm all of the following:

- The custom builder is enabled in `$default`, not only in a separate target.
- The custom builder has `build_to: source`.
- `required_inputs` contains `.js`.
- The custom builder's `build_extensions` key is `tools/drift_worker.dart`.
- `tools/builder.dart` reads `${inputId.path}.js`.
- The destination is exactly `apps/blogstore/web/drift_worker.js`.

### Warning about an unknown builder

For a builder declared by the current package, use the package-local target key:

```yaml
":copy_compiled_worker_js":
  enabled: true
```

Using `copy_compiled_worker_js` without the leading colon can make build_runner interpret it as a different package-qualified builder name.

### The `tools/` directory is ignored

The source glob is directory-sensitive. These are not equivalent:

```yaml
- "tool/**"
- "tools/**"
```

For this repository, only `"tools/**"` includes `tools/drift_worker.dart` and `tools/builder.dart`.

### Module-information warnings

The web compiler may report warnings such as being unable to read module information for Flutter-related packages in a mixed Dart/Flutter workspace. These warnings are separate from worker generation. The important checks are whether the compiler runs and whether `apps/blogstore/web/drift_worker.js` is written.

## Adapting To Another App

To use this pattern for another Flutter app:

1. Put the worker entrypoint in a source directory included by the target, such as `tools/**`.
2. Change `generate_for` to the new worker path.
3. Change the `build_extensions` destination to the app's `web/` directory.
4. Keep the builder input key and the `${inputId.path}.js` lookup synchronized with the new worker path.
5. Run the workspace build from the directory containing the active root `build.yaml`.

For example, a worker at `tools/another_worker.dart` would use:

```yaml
build_extensions:
  "tools/another_worker.dart": ["apps/other_app/web/another_worker.js"]
```

and the builder would read the generated asset at `tools/another_worker.dart.js`.

## Verification Checklist

Before considering the setup complete, verify:

- [ ] `drift`, `build`, `build_runner`, and `build_web_compilers` are available in the root package.
- [ ] `tools/drift_worker.dart` imports `package:drift/wasm.dart`.
- [ ] `$default.sources` contains the exact `"tools/**"` glob.
- [ ] The compiler's `generate_for` path matches the worker source.
- [ ] The custom builder is enabled as `":copy_compiled_worker_js"`.
- [ ] The builder declares `required_inputs: [.js]`.
- [ ] The builder reads the generated `.js` asset, not the Dart source.
- [ ] The output is configured with `build_to: source`.
- [ ] `dart run build_runner build --workspace --delete-conflicting-outputs` completes.
- [ ] `apps/blogstore/web/drift_worker.js` exists after the build.
