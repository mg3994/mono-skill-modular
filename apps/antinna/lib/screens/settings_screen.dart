import 'package:dartnative/dartnative.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.settingsTitle ?? 'Settings';
    final currentLocale = AntinnaApp.of(context)?.currentLocale ?? 'en';

    return Scaffold(
      brightness: Brightness.light,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: const Text('Language / Idioma'),
            subtitle: Text(currentLocale == 'es' ? 'Español' : 'English'),
            onTap: () {
              final newLocale = currentLocale == 'en' ? 'es' : 'en';
              AntinnaApp.of(context)?.setLocale(newLocale);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(l10n?.settingsGeneralTitle ?? 'General'),
            subtitle: Text(l10n?.settingsGeneralSubtitle ?? 'Profile, preferences'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text(l10n?.settingsAppearanceTitle ?? 'Appearance'),
            subtitle: Text(l10n?.settingsAppearanceSubtitle ?? 'Theme, colors, language'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(l10n?.settingsNotificationsTitle ?? 'Notifications'),
            subtitle: Text(l10n?.settingsNotificationsSubtitle ?? 'Alerts, sounds'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text(l10n?.settingsPrivacyTitle ?? 'Privacy & Security'),
            subtitle: Text(l10n?.settingsPrivacySubtitle ?? 'Passwords, access'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
