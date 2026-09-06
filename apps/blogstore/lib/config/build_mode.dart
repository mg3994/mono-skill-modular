import 'package:flutter/foundation.dart';

import 'build_mode_interface.dart';

enum BuildMode implements BuildModeInterface {
  debug,
  profile,
  release;

  static BuildMode get current {
    if (kDebugMode) {
      return BuildMode.debug;
    }

    if (kProfileMode) {
      return BuildMode.profile;
    }

    if (kReleaseMode) {
      return BuildMode.release;
    }

    throw UnimplementedError('Active environment build mode is unrecognized.');
  }
}
