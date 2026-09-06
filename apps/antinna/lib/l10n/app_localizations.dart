import 'package:dartnative/dartnative.dart';
import 'package:intl/intl.dart';

/// Localizations class for the Antinna DartNative application.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    DefaultMaterialLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
  ];

  bool get _isEs => locale.languageCode == 'es';

  String get appName => 'Antinna';

  String get helloWorld => _isEs ? '¡Hola Mundo!' : 'Hello World!';

  String welcomeUser(String userName) =>
      _isEs ? '¡Bienvenido de nuevo, $userName!' : 'Welcome back, $userName!';

  String postCount(int count) {
    if (_isEs) {
      if (count == 0) return 'Sin publicaciones';
      if (count == 1) return '1 publicación';
      return '$count publicaciones';
    }
    if (count == 0) return 'No posts yet';
    if (count == 1) return '1 post';
    return '$count posts';
  }

  String get settingsTitle => _isEs ? 'Configuración' : 'Settings';

  String get settingsGeneralTitle => _isEs ? 'General' : 'General';

  String get settingsGeneralSubtitle =>
      _isEs ? 'Perfil, preferencias' : 'Profile, preferences';

  String get settingsAppearanceTitle => _isEs ? 'Apariencia' : 'Appearance';

  String get settingsAppearanceSubtitle =>
      _isEs ? 'Tema, colores, idioma' : 'Theme, colors, language';

  String get settingsNotificationsTitle =>
      _isEs ? 'Notificaciones' : 'Notifications';

  String get settingsNotificationsSubtitle =>
      _isEs ? 'Alertas, sonidos' : 'Alerts, sounds';

  String get settingsPrivacyTitle =>
      _isEs ? 'Privacidad y Seguridad' : 'Privacy & Security';

  String get settingsPrivacySubtitle =>
      _isEs ? 'Contraseñas, acceso' : 'Passwords, access';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
