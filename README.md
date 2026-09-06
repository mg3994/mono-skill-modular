### Listen Everyone daily new Frameworks that claims being better then flutter , sometimes they are right sometimes wrong , but what if there be a framework that just void dart:ui stuff or rendereing but has a better wrapper (like dartnative) there be some possibility that LEGO approch can make porting easy, so tune yourcodebase in MODULAR monorepo
# Build the workspace

This project uses [`build_runner`](https://pub.dev/packages/build_runner) to
generate code for every Dart package in the workspace. Run the command below
from the workspace root—the directory containing the workspace configuration
and the package folders:

```bash
dart run build_runner build --workspace
```

## Prerequisites

1. Install the Dart SDK or Flutter SDK and verify that it is available:

	 ```bash
	 dart --version
	 ```

2. Ensure `build_runner` is declared as a development dependency in the
	 relevant package(s):

	 ```yaml
	 dev_dependencies:
		 build_runner: 
	 ```

3. Fetch dependencies before running the generator:

	 ```bash
	 dart pub get
	 ```

## Running code generation

Run the build command from the workspace root whenever generated files need to
be created or refreshed. The `--workspace` option makes `build_runner` run the
build for each package in the workspace that contains a build configuration.
Generated files are written next to the source files according to the
configured builders.

To remove stale generated output and rebuild everything from scratch, run:

```bash
dart run build_runner clean
dart run build_runner build --workspace
```

To regenerate files automatically while editing source code, use watch mode:

```bash
dart run build_runner watch --workspace
```

Keep the watch process running in a terminal. It reruns the configured
builders whenever a relevant file changes. Commit generated files only when
the project conventions require them.

## Troubleshooting

- Run the command from the workspace root, not from an individual package.
- Run `dart pub get` after changing dependencies.
- If stale outputs cause conflicts, run `dart run build_runner clean` and then
	build again.
- If a package is not processed, confirm that it has the required
	`build_runner` dependency and builder configuration.
