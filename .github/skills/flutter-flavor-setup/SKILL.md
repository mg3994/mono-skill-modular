---
name: flutter-flavor-setup
description: "Use when adding, configuring, generating, running, or debugging Flutter flavors in this workspace, including flutter_flavorizr, flavorizr.yaml, Android productFlavors, iOS schemes and xcconfig files, Dart defines, appFlavor, build modes, or flavor-specific URLs and services."
---

# Flutter Flavor Setup

Use this skill when changing the application's development, staging, or production flavor configuration. This workspace has a Flutter app under `apps/blogstore` and a reusable flavor configuration model under `packages/core`. Flavor setup has two related but separate responsibilities:

- Native flavor generation and platform identity: Android application IDs, iOS bundle IDs, schemes, display names, icons, and platform resources.
- Runtime selection: selecting the flavor in Dart and constructing the `AppFlavorConfig` consumed by application code.

Keep both layers aligned. A native flavor that does not reach Dart can use the wrong API endpoint, and a Dart-only flavor that has no native identity cannot be selected with `--flavor` on Android or iOS.

## Current Workspace Shape

The relevant paths are:

```text
workspace/
  pubspec.yaml
  apps/
    blogstore/
      pubspec.yaml
      lib/main.dart
      android/app/
      ios/Runner.xcodeproj/
      macos/Runner.xcodeproj/
      web/
  packages/
    core/
      lib/config/flavor.dart
      lib/config/flavor_config.dart
      lib/build_mode/build_mode.dart
      lib/type_def/flavor_type_def.dart
```

The current Dart flavor enum defines:

```dart
enum Flavor implements FlavorInterface {
  development(...),
  staging(...),
  production(...);
}
```

The URL values are read at compile time from these Dart defines:

| Flavor | Dart define | Default |
| --- | --- | --- |
| `development` | `DEV_BLOGGER_URL` | `https://api.dev.yourdomain.com` |
| `staging` | `STG_BLOGGER_URL` | `https://api.stg.yourdomain.com` |
| `production` | `PROD_BLOGGER_URL` | `https://api.prod.yourdomain.com` |

`FlavorConfig<F, B>` combines the selected `Flavor` with `BuildMode`. `BuildMode.current` detects debug, profile, and release through Flutter's `kDebugMode`, `kProfileMode`, and `kReleaseMode`.

Use exactly `development`, `staging`, and `production` unless the product requirements say otherwise. Keep the same spelling across `Flavor`, `flavorizr.yaml`, Android, iOS, IDE launch configurations, CI, and documentation. `FLUTTER_APP_FLAVOR` is the single Dart string-define key for selecting the runtime flavor. Flutter's native `appFlavor`, exported by `package:flutter/services.dart`, may be used to validate or populate that value on supported native targets, but application configuration should read `FLUTTER_APP_FLAVOR` consistently.

## Dependency Placement

`flutter_flavorizr` is a code-generation and project-customization tool. Put it in the Flutter application's `dev_dependencies`, not in `packages/core` runtime dependencies and not in the application `dependencies`:

```yaml
# apps/blogstore/pubspec.yaml
dev_dependencies:
  flutter_flavorizr: ^2.6.0
```

Use the latest version compatible with the repository's Flutter/Dart SDK when updating an existing setup. The version shown above is the known package version used by this skill; verify the current compatible version before changing it.

Resolve dependencies from the application directory because that is where the Flutter platform projects and `flavorizr.yaml` belong:

```powershell
Set-Location apps/blogstore
flutter pub get
```

Do not put `flavorizr.yaml` in `packages/core`. The core package owns flavor types and runtime contracts; the Flutter app owns native project generation.

## flavorizr.yaml

Create `apps/blogstore/flavorizr.yaml`. The current package supports the nested `flavorizr:` form:

```yaml
flavorizr:
  app:
    android:
      flavorDimensions: "flavor-type"
    ios: {}
    macos: {}

  flavors:
    development:
      app:
        name: "BlogStore Development"
      android:
        applicationId: "in.antinna.blogstore.dev"
      ios:
        bundleId: "in.antinna.blogstore.dev"
      macos:
        bundleId: "in.antinna.blogstore.dev"
      linux:
        applicationId: "in.antinna.blogstore.dev"
      windows: {}

    staging:
      app:
        name: "BlogStore Staging"
      android:
        applicationId: "in.antinna.blogstore.stg"
      ios:
        bundleId: "in.antinna.blogstore.stg"
      macos:
        bundleId: "in.antinna.blogstore.stg"
      linux:
        applicationId: "in.antinna.blogstore.stg"
      windows: {}

    production:
      app:
        name: "BlogStore"
      android:
        applicationId: "in.antinna.blogstore"
      ios:
        bundleId: "in.antinna.blogstore"
      macos:
        bundleId: "in.antinna.blogstore"
      linux:
        applicationId: "in.antinna.blogstore"
      windows: {}

  instructions:
    - android:androidManifest
    - android:flavorizrGradle
    - android:buildGradle
    - ios:podfile
    - ios:xcconfig
    - ios:buildTargets
    - ios:schema
    - ios:plist
    - macos:podfile
    - macos:xcconfig
    - macos:configs
    - macos:buildTargets
    - macos:schema
    - macos:plist
```

The identifiers above are examples based on the existing production identifier. Confirm the application's registered identifiers, signing teams, Apple provisioning profiles, Firebase projects, and store package names before using them.

Important configuration rules:

- Every flavor needs an `app.name`. Android needs `applicationId`; iOS and macOS need `bundleId`.
- Android flavor names become Gradle product flavors and require a flavor dimension.
- iOS flavors are represented by generated targets, build configurations, and schemes. The scheme name is normally the flavor name.
- Linux and Windows support is different from Android/iOS. Include their entries only when those platforms need distinct identity or generated assets.
- Do not add Firebase or Huawei configuration until each flavor has its own reviewed native service file. `flutter_flavorizr` copies/applies configuration; it does not create provider projects or replace native dependencies.
- Keep `instructions` explicit when the repository already contains application code. The default processor set also includes Flutter example app generators, platform dummy assets, and IDE configuration. Those can overwrite or add files that are not part of this app's architecture.

## Running Flavorizr

Run commands from `apps/blogstore`, not from the workspace root:

```powershell
Set-Location apps/blogstore
flutter pub get
dart pub run flutter_flavorizr
```

The package documentation also supports the Flutter invocation:

```powershell
flutter pub run flutter_flavorizr
```

Use `dart pub run flutter_flavorizr` when that is the repository's documented command. Use `flutter pub run` if the Dart invocation cannot resolve Flutter SDK dependencies in the installed toolchain.

Useful options:

```powershell
# Print processor details.
dart pub run flutter_flavorizr --verbose

# Skip the confirmation prompt in a scripted, reviewed environment.
dart pub run flutter_flavorizr --force

# Run only selected processors; order matters.
dart pub run flutter_flavorizr --processors android:flavorizrGradle,android:buildGradle
```

Do not use `--force` as a substitute for reviewing the diff. Flavorizr edits native project files, generated configuration files, assets, and sometimes Dart files. Run it on a clean branch or save unrelated work first, then inspect `git diff` immediately.

If assets are required, run `assets:download` before `assets:extract`, and run both before processors that consume generated assets. Avoid dummy icon processors when real flavor icons are not ready; generated placeholder assets should not silently ship.

## Generated File Policy

Treat `flavorizr.yaml` as the source of truth for generated platform flavor structure. Do not hand-edit generated flavor files and then expect them to survive the next generation run.

After generation:

1. Inspect Android `build.gradle`/`build.gradle.kts`, manifest, source sets, and resource directories.
2. Inspect iOS/macOS targets, schemes, build configurations, xcconfig includes, bundle identifiers, and `Info.plist` values.
3. Check that existing signing, deployment target, Flutter build settings, and package identifiers were preserved.
4. Remove generated example Dart files or sample pages if they are not part of the application.
5. Decide which generated files belong in source control. Commit reproducible native configuration and required assets; do not commit secrets, local provisioning profiles, downloaded temporary archives, or machine-specific IDE state.
6. Run `flutter pub get`, format changed Dart/YAML, and run the relevant tests/build checks.

Regeneration can produce conflicts with manual native changes. When a native customization is required, prefer a supported `flavorizr.yaml` field or an included xcconfig file. If manual editing is unavoidable, document that the change must be reapplied after generation.

## Dart Runtime Selection

The runtime layer must construct the object passed into `MyApp` and must use one selected flavor consistently. A typical pattern is:

```dart
import 'package:core/core.dart';
import 'package:flutter/material.dart';

void main() {
  final flavorName = const String.fromEnvironment(
    'FLUTTER_APP_FLAVOR',
    defaultValue: 'production',
  );
  final config = AppFlavorConfig(
    flavor: Flavor.fromString(flavorName),
    buildMode: BuildMode.current,
  );

  runApp(MyApp(config: config));
}
```

Adapt the import to the public exports actually provided by `packages/core`. Do not copy the flavor enum into the application. Keep URL selection in `packages/core/lib/config/flavor.dart` and keep app bootstrap in `apps/blogstore`.

When native flavor selection is enabled, Flutter/Flavorizr commonly exposes the selected native flavor through `appFlavor` and forwards it as `FLUTTER_APP_FLAVOR`. The Dart runtime should use the string environment value consistently. A robust policy is:

1. Native Android/iOS flavor selection supplies `FLUTTER_APP_FLAVOR` when generated platform configuration supports it.
2. Web and other Dart-only targets receive `FLUTTER_APP_FLAVOR` through `--dart-define`.
3. If both native `appFlavor` and an explicit `FLUTTER_APP_FLAVOR` are available, validate that they match instead of silently selecting different flavors.
4. Default to `production` only for an intentional release-safe fallback.

Do not assume `String.fromEnvironment` values can be changed during hot reload. Flavor and URL defines are compile-time values, so use a full restart or rebuild after changing them.

## Run And Build Commands

Run native flavors from the app directory:

```powershell
Set-Location apps/blogstore

flutter run --flavor development --dart-define=FLUTTER_APP_FLAVOR=development
flutter run --flavor staging --dart-define=FLUTTER_APP_FLAVOR=staging
flutter run --flavor production --dart-define=FLUTTER_APP_FLAVOR=production
```

Override an endpoint explicitly when needed:

```powershell
flutter run --flavor development `
  --dart-define=FLUTTER_APP_FLAVOR=development `
  --dart-define=DEV_BLOGGER_URL=https://api.dev.example.com
```

For release/profile builds, use the same flavor and define pair:

```powershell
flutter build apk --flavor staging --release --dart-define=FLUTTER_APP_FLAVOR=staging
flutter build appbundle --flavor production --release --dart-define=FLUTTER_APP_FLAVOR=production
flutter build ios --flavor staging --release --dart-define=FLUTTER_APP_FLAVOR=staging
```

The native `--flavor` flag is meaningful only after Android product flavors or iOS schemes have been generated and reviewed. Web does not use native Android/iOS flavor selection; use Dart defines:

```powershell
flutter run -d chrome --dart-define=FLUTTER_APP_FLAVOR=development
flutter build web --dart-define=FLUTTER_APP_FLAVOR=production
```

For web, ensure the runtime code does not require `appFlavor` from a native platform channel. Keep web selection entirely Dart-define based or provide a tested fallback.

## Android Requirements

Flavorizr should generate a `flavorDimensions` value and a `productFlavors` block. Verify that:

- `development`, `staging`, and `production` each have the intended `applicationId`.
- Existing `namespace`, compile SDK, min SDK, target SDK, version code, and signing behavior remain intact.
- Release signing is not accidentally changed to debug signing for production.
- Flavor-specific resources are under the expected source sets and the manifest uses flavor-aware labels where intended.
- `flutter run --flavor <name>` selects the expected application ID and launcher label.

Do not infer a successful Android setup solely from a successful Dart compilation. Install or build each requested variant and inspect the resulting package/application ID.

## iOS And macOS Requirements

Flavorizr creates flavor-specific xcconfig files, targets, and schemes. After generation:

- Open the `.xcworkspace` when CocoaPods is present, not only the `.xcodeproj`.
- Verify every scheme has Debug, Profile, and Release mappings where the application supports those modes.
- Verify `PRODUCT_BUNDLE_IDENTIFIER`, display name, signing team, provisioning profile, deployment target, and `Info.plist` values per flavor.
- Run `pod install` when generated Podfile or target changes require it.
- Select the generated scheme in Xcode before running an iOS flavor.
- Check that production signing and entitlements were not copied to development or staging unintentionally.
- Treat macOS flavor support separately; terminal support may differ from Xcode scheme support for the installed Flutter version.

## Services And Secrets

For Firebase or other flavor-specific services, keep files outside source control when they contain secrets or project credentials. Configure each flavor's native file explicitly, for example:

```yaml
flavors:
  development:
    android:
      applicationId: "in.antinna.blogstore.dev"
      firebase:
        config: ".firebase/development/google-services.json"
    ios:
      bundleId: "in.antinna.blogstore.dev"
      firebase:
        config: ".firebase/development/GoogleService-Info.plist"
```

Check `.gitignore`, CI secret injection, and release packaging before adding provider files. Flavorizr only applies the paths; it does not validate that the files belong to the matching bundle ID.

## Verification Checklist

A flavor setup is complete only when:

- `flutter_flavorizr` is in `apps/blogstore` `dev_dependencies`.
- `apps/blogstore/flavorizr.yaml` defines the same flavor names as `packages/core`.
- `dart pub run flutter_flavorizr` completes from `apps/blogstore`.
- Generated native files are reviewed and do not overwrite unrelated application code.
- Android builds or runs each required flavor with the expected application ID.
- iOS schemes build or run each required flavor with the expected bundle ID.
- Web uses a tested Dart-define path rather than assuming native `--flavor` support.
- `main.dart` constructs and passes `AppFlavorConfig` with both `Flavor` and `BuildMode`.
- URL defines are tested for development, staging, and production, including the default behavior.
- Runtime diagnostics or a focused test prove the selected flavor reaches the API client/configuration layer.
- Debug, profile, and release behavior is checked where the app supports all three modes.
- `flutter analyze` and the focused core/application tests pass.
- A clean regeneration produces no unexplained changes.

## Common Failures

- **`--flavor` is not recognized or selects nothing:** native product flavors/schemes have not been generated, or the command is being run against the wrong app directory.
- **The app starts with the production URL:** `FLUTTER_APP_FLAVOR` is missing, does not match the native `appFlavor`, or the default fallback is hiding the missing define.
- **Flavorizr overwrites application files:** the default processor set included `flutter:main`, `flutter:app`, or `flutter:pages`; use an explicit processor list and restore the app entrypoint from the intended source architecture.
- **iOS build cannot find a file list or pod target:** run CocoaPods after target/Podfile generation and open the workspace; inspect generated xcconfig include paths.
- **Android installs over another flavor:** application IDs are identical; every independently installable flavor needs a distinct ID.
- **Dart changes do not affect the running flavor:** compile-time defines require a full rebuild or restart, not just hot reload.
- **Production credentials appear in a non-production build:** review flavor-specific service files, xcconfig values, Gradle resources, and CI define injection before shipping.
