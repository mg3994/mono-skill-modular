import 'package:dartnative/dartnative.dart';

import '../screens/details_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

/// Centralized route definitions and map for Antinna in DartNative.
abstract class AppRouter {
  static const String home = '/';
  static const String details = '/details';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        home: (BuildContext context) => const HomeScreen(),
        details: (BuildContext context) =>
            const DetailsScreen(itemTitle: 'DartNative Architecture'),
        settings: (BuildContext context) => const SettingsScreen(),
      };
}
