import 'package:dartnative/dartnative.dart';
import 'package:intl/intl.dart';

/// AppLocalizations provides localized strings for Antinna using package:intl.
class AppLocalizations {
  final String languageCode;

  AppLocalizations([String? localeCode])
      : languageCode = localeCode ?? Intl.shortLocale(Intl.defaultLocale ?? 'en');

  static AppLocalizations? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppLocalizationsScope>()
        ?.localizations;
  }

  static Future<AppLocalizations> load(String localeCode) async {
    final canonical = Intl.canonicalizedLocale(localeCode);
    Intl.defaultLocale = canonical;
    return AppLocalizations(canonical);
  }

  bool get isSpanish => languageCode.startsWith('es');

  String get appName => Intl.message('Antinna', name: 'appName');

  String get helloWorld => isSpanish ? '¡Hola Mundo!' : 'Hello World!';

  String welcomeUser(String userName) =>
      isSpanish ? '¡Bienvenido de nuevo, $userName!' : 'Welcome back, $userName!';

  String postCount(int count) {
    return Intl.plural(
      count,
      zero: isSpanish ? 'Sin publicaciones' : 'No posts yet',
      one: isSpanish ? '1 publicación' : '1 post',
      other: isSpanish ? '$count publicaciones' : '$count posts',
      name: 'postCount',
      args: [count],
    );
  }

  String get settingsTitle => isSpanish ? 'Configuración' : 'Settings';

  String get settingsGeneralTitle => isSpanish ? 'General' : 'General';

  String get settingsGeneralSubtitle =>
      isSpanish ? 'Perfil, preferencias' : 'Profile, preferences';

  String get settingsAppearanceTitle => isSpanish ? 'Apariencia' : 'Appearance';

  String get settingsAppearanceSubtitle =>
      isSpanish ? 'Tema, colores, idioma' : 'Theme, colors, language';

  String get settingsNotificationsTitle =>
      isSpanish ? 'Notificaciones' : 'Notifications';

  String get settingsNotificationsSubtitle =>
      isSpanish ? 'Alertas, sonidos' : 'Alerts, sounds';

  String get settingsPrivacyTitle =>
      isSpanish ? 'Privacidad y Seguridad' : 'Privacy & Security';

  String get settingsPrivacySubtitle =>
      isSpanish ? 'Contraseñas, acceso' : 'Passwords, access';
}

/// InheritedWidget providing AppLocalizations down the widget tree.
class AppLocalizationsScope extends InheritedWidget {
  final AppLocalizations localizations;

  const AppLocalizationsScope({
    super.key,
    required this.localizations,
    required super.child,
  });

  @override
  bool updateShouldNotify(AppLocalizationsScope oldWidget) {
    return localizations.languageCode != oldWidget.localizations.languageCode;
  }
}
