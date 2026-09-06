import '../build_mode/build_mode.dart' show BuildMode;
import '../config/config.dart' show Flavor, FlavorConfig;

// ignore: depend_on_referenced_packages
export 'package:flutter/services.dart' show appFlavor;

/// A type alias for the application's flavor and build-mode configuration.
///
/// Example:
/// ```
/// final AppFlavorConfig appFlavorConfig = FlavorConfig(
///   flavor: Flavor.fromString(
///     const String.fromEnvironment('FLAVOR', defaultValue: 'production'),
///   ),
///   buildMode: BuildMode.current,
/// );
/// ```

typedef AppFlavorConfig = FlavorConfig<Flavor, BuildMode>;
