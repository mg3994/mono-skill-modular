---
name: flutter-localization-workspace
description: "Use when working on Flutter ARB localization, l10n.yaml, generated AppLocalizations code, Flutter workspace packages, adding locales, or diagnosing why localization files are not generated."
---

# Flutter Localization In This Workspace

This skill documents the localization setup used by this Dart/Flutter workspace. Load it before changing ARB files, `l10n.yaml`, Flutter generation settings, localization imports, or the localization package layout.

## Current Project Shape

The repository is a Dart workspace. The root package owns the workspace-level localization configuration, while the localization package owns the ARB input files and generated Dart output:

```text
workspace/
  l10n.yaml
  pubspec.yaml
  packages/
    l10n/
      pubspec.yaml
      lib/
        l10n/
          app_en.arb
        generated/
          app_localizations.dart
          app_localizations_en.dart
        l10n.dart
      test/
```

The package is listed by the root workspace with:

```yaml
workspace:
  - packages/**
```

The localization package has `resolution: workspace`, so it is resolved as a member of the root workspace rather than as an unrelated standalone project.

## Root Flutter Generation Flag

The root `pubspec.yaml` contains:

```yaml
flutter:
  generate: true
```

This flag is required because the root package owns `l10n.yaml` and is the package from which Flutter localization generation is invoked. It tells Flutter that generated localization source is part of the project and may be imported by application code.

The localization package also currently contains the same `flutter.generate` setting. Keeping it there is harmless when the package is treated independently, but the root setting is the important one for the current root-level configuration.

Do not leave the root setting commented out:

```yaml
# flutter:
#   generate: true
```

With the flag commented out, `flutter gen-l10n` fails with an error stating that localization code was attempted without `flutter: generate: true`.

## Current `l10n.yaml`

The complete current configuration is:

```yaml
arb-dir: packages/l10n/lib/l10n
output-dir: packages/l10n/lib/generated
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getters: false
untranslated-messages-file: packages/l10n/build/untranslated.json
use-escaping: false
use-deferred-loading: true
relax-syntax: true
required-resource-attributes: false
```

All paths are relative to the workspace root because `l10n.yaml` is at the workspace root. In particular, these paths must include `packages/l10n`:

| Option | Value | Meaning |
| --- | --- | --- |
| `arb-dir` | `packages/l10n/lib/l10n` | Directory containing input ARB files. |
| `output-dir` | `packages/l10n/lib/generated` | Directory receiving generated Dart files. |
| `template-arb-file` | `app_en.arb` | Base/template catalog used to define the message API. |
| `output-localization-file` | `app_localizations.dart` | Main generated localization entrypoint. |
| `output-class` | `AppLocalizations` | Generated Dart class name. |
| `nullable-getters` | `false` | Generated message getters are non-nullable. Missing translations must be handled by the generation strategy rather than by nullable getter types. |
| `untranslated-messages-file` | `packages/l10n/build/untranslated.json` | Report of messages that are untranslated or missing in locale catalogs. |
| `use-escaping` | `false` | Keeps the default ARB message escaping behavior. |
| `use-deferred-loading` | `true` | Enables deferred loading support in generated localization code where Flutter supports it. |
| `relax-syntax` | `true` | Allows the relaxed ICU/ARB syntax supported by Flutter's localization generator. |
| `required-resource-attributes` | `false` | Does not require every resource to declare all optional metadata attributes. |

An earlier configuration used `project-dir: packages/l10n` with `arb-dir: lib/l10n` and `output-dir: lib/generated`. In this root-level workspace setup, Flutter still resolved those directories from the root and looked for `lib/l10n`. The reliable configuration is to use explicit root-relative paths as shown above.

## What The ARB File Contains

The template file is `packages/l10n/lib/l10n/app_en.arb`. It starts with the locale declaration and a language display name:

```json
{
  "@@locale": "en",
  "languageName": "English",
  "@languageName": {
    "description": "Native display name of the language"
  }
}
```

The catalog currently defines these messages (for examples):

| Message | Parameters | Purpose |
| --- | --- | --- |
| `languageName` | none | Native name of the locale. |
| `appName` | none | Application name, currently `BlogStore`. |
| `helloWorld` | none | Conventional greeting. |
| `pronoun` | `gender: String` | ICU `select` message for `male`, `female`, and `other`. |
| `welcomeUser` | `userName: String` | Personalized welcome message. |
| `postCount` | `count: int` | ICU plural message for zero, one, and other counts. |
| `readingTime` | `minutes: int` | Reading-time plural message. |
| `searchResults` | `count: int`, `query: String` | Plural search-result summary with a nested query value. |
| `authorRole` | `role: String` | ICU `select` message for author, editor, admin, and other roles. |
| `articlePrice` | `amount: double` | Numeric value using the `compactCurrency` format. |
| `publishedDate` | `date: DateTime` | Date value using the `yMMMd` format. |
| `publishedTime` | `time: DateTime` | Time value using the `jm` format. |
| `settingsTitle` | none | Settings screen title. |
| `searchSettings` | none | Settings search placeholder. |
| `noSettingsFound` | none | Empty search result message. |
| `settingsGeneralTitle` | none | General settings category title. |
| `settingsGeneralSubtitle` | none | General settings category subtitle. |
| `settingsAppearanceTitle` | none | Appearance settings category title. |
| `settingsAppearanceSubtitle` | none | Appearance settings category subtitle. |
| `settingsNotificationsTitle` | none | Notifications settings category title. |
| `settingsNotificationsSubtitle` | none | Notifications settings category subtitle. |
| `settingsPrivacyTitle` | none | Privacy and security category title. |
| `settingsPrivacySubtitle` | none | Privacy and security category subtitle. |

Messages with parameters have an `@messageName` metadata object. Parameter metadata declares the type and, where needed, a formatting style. For example:

```json
"postCount": "{count, plural, =0{No posts yet} =1{1 post} other{# posts}}",
"@postCount": {
  "description": "The number of posts in a catalog",
  "placeholders": {
    "count": {
      "type": "int"
    }
  }
}
```

The `@@locale` key identifies the catalog locale. A locale-specific catalog should keep the same message keys as the template and change only the translated values and locale metadata.

## How Generation Works

Flutter reads the root `l10n.yaml`, loads the template and locale ARB files, and writes Dart source into the configured output directory. The normal explicit command is:

```powershell
flutter gen-l10n
```

After successful generation, the expected files include:

```text
packages/l10n/lib/generated/app_localizations.dart
packages/l10n/lib/generated/app_localizations_en.dart
packages/l10n/build/untranslated.json
```

The generated files are derived artifacts. Edit the ARB files and configuration, not the generated Dart files. Regenerate after changing a message, placeholder, locale, or l10n option.

`flutter pub get` resolves dependencies and updates package metadata. It does not translate message values and should not be confused with localization generation.

`flutter: generate: true` also allows Flutter build tooling to invoke localization generation as part of a Flutter build workflow. It does not automatically translate English text into another language. Human or machine-produced translations still need to be placed in additional ARB files such as `app_es.arb`, and those files must use the same message keys and compatible placeholders.

## Adding A Locale

1. Create a new ARB file beside the template, for example `packages/l10n/lib/l10n/app_es.arb`.
2. Set its locale metadata:

   ```json
   {
     "@@locale": "es",
    "languageName": "Espanol",
     "appName": "BlogStore"
   }
   ```

3. Copy every template message key into the new catalog.
4. Translate the values while preserving ICU syntax, placeholder names, and placeholder types.
5. Run `flutter gen-l10n` from the workspace root.
6. Inspect `packages/l10n/build/untranslated.json` for missing messages.

For example, `{userName}` must remain `{userName}` in every locale. Renaming it in a translation without changing the template causes the generated API and translation to disagree.

## Consuming The Generated API

The package exposes a barrel file at `packages/l10n/lib/l10n.dart`:

```dart
library;

export 'generated/app_localizations.dart';
export 'package:intl/intl.dart';
```

Application code should import the package API rather than importing generated implementation details from arbitrary filesystem paths. In a Flutter application, provide the generated delegate and supported locales through `MaterialApp` or `CupertinoApp` according to the generated API:

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
)
```

### Delegates For Decoupled UI Packages

When the application uses decoupled UI packages, prefer the localization delegates exposed by the package that owns each UI system. This keeps Material and Cupertino localization behavior with the corresponding package instead of coupling the application directly to `flutter_localizations`.

For a Material-based package, use its Material delegates:

Before:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

// ...
localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
  GlobalCupertinoLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
],
```

After:

```dart
import 'package:material_ui/material_ui.dart';

// ...
localizationsDelegates: GlobalMaterialLocalizations.delegates,
```

Use the equivalent delegates from `package:cupertino_ui` when the application uses the decoupled Cupertino package. If an application uses both UI systems, include the delegates from both packages together with `AppLocalizations.localizationsDelegates`.

The direct generated-localization lookup remains valid:

```dart
final strings = AppLocalizations.of(context)!;
Text(strings.welcomeUser('Mina'));
```

For a shared convenience API, the application can expose generated, Material, and Cupertino strings through `BuildContext` extensions:

```dart
extension BuildContextLocalizationExtensions on BuildContext {
  /// The application's generated localization strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Material localization strings.
  MaterialLocalizations get m10n => MaterialLocalizations.of(this);

  /// Cupertino localization strings.
  CupertinoLocalizations get c10n => CupertinoLocalizations.of(this);
}
```

When using decoupled UI packages, import these types from their owning packages:

```dart
import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoLocalizations;
import 'package:material_ui/material_ui.dart'
    show BuildContext, MaterialLocalizations, Theme, ThemeData;

import '../../generated/app_localizations.dart' show AppLocalizations;
```

Otherwise, use the corresponding Flutter imports, such as `package:flutter/cupertino.dart` and `package:flutter/material.dart`, together with the package's generated localization API. The extension is optional; direct calls such as `AppLocalizations.of(context)!` remain correct.

The exact generated method signatures should be checked after generation, especially for ICU messages and formatted `DateTime`, `double`, and `int` placeholders.

## Validation Checklist

When localization generation appears broken, check in this order:

1. Confirm the command is run from the workspace root.
2. Confirm root `pubspec.yaml` contains an active `flutter: generate: true` block.
3. Confirm `l10n.yaml` exists at the root and its paths begin with `packages/l10n`.
4. Confirm `packages/l10n/lib/l10n/app_en.arb` exists and is valid JSON.
5. Run `flutter gen-l10n` and read the first error rather than running `build_runner`.
6. Confirm generated files exist under `packages/l10n/lib/generated`.
7. Inspect `packages/l10n/build/untranslated.json`.
8. Run package analysis or tests after generation.

The command `dart run build_runner watch --workspace` is not the localization generator. Build Runner is for packages that use code generators registered with `build_runner`; Flutter ARB localization uses Flutter's `gen-l10n` tooling.

## Common Failures

### Generate flag disabled

Symptom:

```text
Attempted to generate localizations code without having the flutter: generate flag turned on.
```

Fix the root `pubspec.yaml` and run `flutter gen-l10n` again.

### ARB directory does not exist

Symptom:

```text
The 'arb-dir' directory ... lib/l10n ... does not exist.
```

This usually means root-relative paths were omitted. Use:

```yaml
arb-dir: packages/l10n/lib/l10n
output-dir: packages/l10n/lib/generated
```

### Generated files edited manually

Manual edits disappear on the next generation run. Change the ARB source or `l10n.yaml`, then regenerate.

### Analysis reports a missing generated import

Ensure generation completed and the import points to the package's `lib` source API. A test import such as `import 'generated/app_localizations.dart';` is resolved relative to the test directory and does not refer to `lib/generated`. Prefer a package import or the package barrel export.

### Missing `package:lints/recommended.yaml`

This is a dependency/configuration issue separate from ARB generation. Add the appropriate `lints` dev dependency to the package that owns the analysis options, then run `dart pub get` if the project intends to use that lint set.

## Maintenance Rules

- Keep `l10n.yaml` paths correct for its location; do not assume paths are relative to `packages/l10n`.
- Keep the template and locale placeholder names synchronized.
- Keep generated output out of hand-written source edits.
- Add a new locale by adding an ARB file, not by modifying generated Dart.
- Run `flutter gen-l10n` after every ARB or l10n configuration change.
- Treat untranslated-message reports as part of localization validation.
- Update this skill when the workspace layout or generation strategy changes.