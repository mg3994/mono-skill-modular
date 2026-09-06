import 'package:dartnative/dartnative.dart';
import 'package:l10n/l10n.dart';
import '../router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final welcomeText = l10n?.welcomeUser('DartNative User') ?? '👋 Welcome';
    final helloWorld = l10n?.helloWorld ?? 'Hello World!';

    return Scaffold(
      brightness: Brightness.light,
      appBar: AppBar(
        title: Text(
          l10n?.appName ?? 'Antinna',
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.settings);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              welcomeText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF111111),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              helloWorld,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6B6B70),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.details,
                  arguments: 'DartNative Modular Architecture',
                );
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
