import '../build_mode/build_mode.dart' show BuildMode;
import '../config/flavor.dart' show Flavor;
import '../config/flavor_config.dart' show FlavorConfig;

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
