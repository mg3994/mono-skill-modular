import 'package:dartnative/dartnative.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.settingsTitle ?? 'Settings';

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
            leading: const Icon(Icons.person),
            title: Text(l10n?.settingsGeneralTitle ?? 'General'),
            subtitle: Text(l10n?.settingsGeneralSubtitle ?? 'Profile, preferences'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n?.settingsAppearanceTitle ?? 'Appearance'),
            subtitle: Text(l10n?.settingsAppearanceSubtitle ?? 'Theme, colors, language'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n?.settingsNotificationsTitle ?? 'Notifications'),
            subtitle: Text(l10n?.settingsNotificationsSubtitle ?? 'Alerts, sounds'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(l10n?.settingsPrivacyTitle ?? 'Privacy & Security'),
            subtitle: Text(l10n?.settingsPrivacySubtitle ?? 'Passwords, access'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
