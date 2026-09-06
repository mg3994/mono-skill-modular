import 'package:core/build_mode/build_mode_interface.dart'
    show BuildModeInterface;

enum BuildMode implements BuildModeInterface {
  debug,
  profile,
  release;

  static BuildMode get current {
    if (const bool.fromEnvironment('dart.vm.profile')) {
      return BuildMode.profile;
    }

    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.release;
    }

    return BuildMode.debug;
  }
}
