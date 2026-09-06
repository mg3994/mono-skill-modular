# antinna

A **dartnative** app, scaffolded by `dn create`. It ships with correct iOS +
Android runner glue (so it renders instead of white-screening) and is ready for a
branded splash + app icon.

## Run it

```sh
dn pub get
dn run -d <device-id>
```

dartnative apps require a license. Subscribe at
[dartpub.dev/framework](https://dartpub.dev/framework), copy your license key
(`dnk_...`) from the Framework panel, and configure it once:

```sh
dn config --license-key dnk_...
```

After that `dn run` just works, on every platform. (Prefer not to store the
key? Pass it per run instead: `dn run --dart-define=DN_LICENSE_KEY=dnk_...`.)

Always use **`dn`** for run/build/pub commands — not the underlying SDK CLI.

## Make it yours

- **Your UI** — edit `lib/main.dart`.
- **App icon + launch logo** — replace `assets/dn-logo.png` with your logo, then
  regenerate icon **and** splash in one step:
  ```sh
  dart run tool/generate_app_assets.dart --source=assets/dn-logo.png --bg=#000000
  ```
  (Splash only: `dart run dartnative_splash:setup`.)
- **Plugins** — browse **[dartpub.dev](https://dartpub.dev)**. Add a package to
  `pubspec.yaml`, run `dn pub get`, and import it — pure-Dart packages and
  dartnative plugins both work as-is.

## Don't touch (unless you know the runtime)

These files are the dartnative runner glue — they're why the app renders:
`ios/Runner/{AppDelegate,SceneDelegate}.swift` + the scene block in `Info.plist`,
and `android/.../{Application,MainActivity}.kt` + the Material3 themes in
`android/app/src/main/res/values*/styles.xml`.

> Dependency paths in `pubspec.yaml` assume this app sits beside
> `dartnative_framework`. Fix them if you created it elsewhere.

#How it looks

```
 dn create --org in antinna
DartNative assets will be downloaded from https://cdn.dartnative.com. Make sure you trust this source!
Downloading Gradle Wrapper...                                      567ms
Downloading package sky_engine...                                  27.3s
Downloading patched_sdk tools...                                    7.4s
Downloading patched_sdk_product tools...                            6.1s
Downloading windows-x64 tools...                                   14.1s
Downloading DartNative headers...                                   7.5s
Downloading DartNative plugin modules...                           15.0s
Downloading DartNative binding natives...                          12.6s
Downloading the code push difference tool...                     2,243ms
Downloading windows-x64/font-subset tools...                     2,374ms
Creating project antinna...
dartnative: the native modules for dartnative_skia, dartnative_ios are missing from the SDK cache (a
framework bake reinstalls headers without them); fetching them again before the build.
dartnative: no native artifact published for dartnative_skia@1.0.0 (the SDK-locked version); the iOS
build may fail to link dartnative_skia
dartnative: no native artifact published for dartnative_ios@1.0.0 (the SDK-locked version); the iOS
build may fail to link dartnative_ios
Resolving dependencies in `antinna`...
Downloading packages...
Got dependencies in `antinna`.
dartnative: no native artifact published for dartnative_skia@1.0.0 (the SDK-locked version); the iOS
build may fail to link dartnative_skia
dartnative: no native artifact published for dartnative_ios@1.0.0 (the SDK-locked version); the iOS
build may fail to link dartnative_ios
Wrote 72 files.

All done!
You can find general documentation for DartNative at: https://dartnative.com/docs
Detailed API documentation is available at: https://dartnative.com/docs

In order to run your application, type:

  $ cd antinna
  $ dn run

Your application code is in antinna\lib\main.dart.

Newer than known valid Java version (28.0.0), gradle (8.14).
 Treating as valid configuration.
The configured version of Java detected may conflict with the Gradle version in your new DartNative app.
To keep the default Gradle version 8.14, download a compatible Java version
(Java 17 <= compatible Java version < Java 25). Configure this Java version globally for DartNative by
running:

  dn config --jdk-dir=<JDK_DIRECTORY>


Alternatively, to continue using your configured Java version, update the Gradle
version specified in the following file to a compatible Gradle version:
C:\Users\manis\Desktop\workspace\workspace\apps\antinna\android/gradle/wrapper/gradle-wrapper.properties
You may also update the Gradle version used by running
`./gradlew wrapper --gradle-version=<COMPATIBLE_GRADLE_VERSION>`.

See
https://docs.gradle.org/current/userguide/compatibility.html#java for details
on compatible Java/Gradle versions, and see
https://docs.gradle.org/current/userguide/gradle_wrapper.html#sec:upgrading_wrapper
for more details on using the Gradle Wrapper command to update the Gradle version
used.



PS C:\Users\manis\Desktop\workspace\workspace\apps> 
```