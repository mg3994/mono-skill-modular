import 'package:dartnative/dartnative.dart';
import '../screens/details_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';

/// Centralized router configuration for Antinna following DartNative architecture guidelines.
abstract class AppRouter {
  static const String home = '/';
  static const String details = '/details';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomeScreen(),
          settings: routeSettings,
        );
      case details:
        final args = routeSettings.arguments;
        final title = args is String ? args : null;
        return MaterialPageRoute<dynamic>(
          builder: (_) => DetailsScreen(itemTitle: title),
          settings: routeSettings,
        );
      case settings:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SettingsScreen(),
          settings: routeSettings,
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Route Not Found')),
            body: const Center(child: Text('404 - Page not found')),
          ),
          settings: routeSettings,
        );
    }
  }
}
