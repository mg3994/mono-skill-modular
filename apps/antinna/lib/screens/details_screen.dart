import 'package:dartnative/dartnative.dart';
import 'package:l10n/l10n.dart';

class DetailsScreen extends StatelessWidget {
  final String? itemTitle;

  const DetailsScreen({super.key, this.itemTitle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      brightness: Brightness.light,
      appBar: AppBar(
        title: Text(
          itemTitle ?? 'Details',
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 64,
              color: Color(0xFF007AFF),
            ),
            const SizedBox(height: 16),
            Text(
              itemTitle ?? 'Detail Overview',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n != null
                  ? l10n.postCount(1)
                  : '1 item in catalog',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B6B70),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
