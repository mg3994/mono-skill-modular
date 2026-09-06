import 'package:dartnative/dartnative.dart';

/// AppLocalizations provides localized strings for Antinna in DartNative.
class AppLocalizations {
  final String languageCode;

  const AppLocalizations(this.languageCode);

  static AppLocalizations? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppLocalizationsScope>()
        ?.localizations;
  }

  bool get isSpanish => languageCode == 'es';

  String get appName => 'Antinna';

  String get helloWorld => isSpanish ? '¡Hola Mundo!' : 'Hello World!';

  String welcomeUser(String userName) =>
      isSpanish ? '¡Bienvenido de nuevo, $userName!' : 'Welcome back, $userName!';

  String postCount(int count) {
    if (isSpanish) {
      if (count == 0) return 'Sin publicaciones';
      if (count == 1) return '1 publicación';
      return '$count publicaciones';
    }
    if (count == 0) return 'No posts yet';
    if (count == 1) return '1 post';
    return '$count posts';
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
