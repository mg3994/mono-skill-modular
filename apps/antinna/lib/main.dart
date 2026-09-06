import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';

void main() {
  // Platform bindings + (once you add plugins) their FFI symbols. Keep this
  // as the FIRST line of main() — see lib/dartnative_plugin_registrant.dart.
  DartNativePluginRegistrant.registerAll();

  // App-wide system chrome default for the white template: dark status-bar
  // icons over the light background, transparent strips. Screens can override
  // in initState; the navigator restores this default on pop.
  SystemChrome.defaultStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  runApp(const AntinnaApp());
}

/// Root application widget configuring localization and routing for DartNative.
class AntinnaApp extends StatefulWidget {
  const AntinnaApp({super.key});

  static AntinnaAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<AntinnaAppState>();
  }

  @override
  State<AntinnaApp> createState() => AntinnaAppState();
}

class AntinnaAppState extends State<AntinnaApp> {
  String _localeCode = 'en';

  void setLocale(String localeCode) {
    setState(() {
      _localeCode = localeCode;
    });
  }

  String get currentLocale => _localeCode;

  @override
  Widget build(BuildContext context) {
    return AppLocalizationsScope(
      localizations: AppLocalizations(_localeCode),
      child: MaterialApp(
        title: 'Antinna',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.home,
        routes: AppRouter.routes,
      ),
    );
  }
}
