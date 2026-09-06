import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Flavor & Build Mode configuration
  final appFlavorConfig = AppFlavorConfig(
    flavor: Flavor.fromString(
      const String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'production'),
    ),
    buildMode: BuildMode.current,
  );

  // Initialize Infrastructure & Domain repositories
  final db = AppDatabase();
  final appearanceRepo = DriftAppearanceRepository(db);
  final postRepo = InMemoryPostRepository();

  runApp(
    BlogStoreApp(
      config: appFlavorConfig,
      getAppearanceSettings: GetAppearanceSettings(appearanceRepo),
      saveAppearanceSettings: SaveAppearanceSettings(appearanceRepo),
      getPosts: GetPosts(postRepo),
      searchPosts: SearchPosts(postRepo),
    ),
  );
}

class BlogStoreApp extends StatelessWidget {
  const BlogStoreApp({
    super.key,
    required this.config,
    required this.getAppearanceSettings,
    required this.saveAppearanceSettings,
    required this.getPosts,
    required this.searchPosts,
  });

  final AppFlavorConfig config;
  final GetAppearanceSettings getAppearanceSettings;
  final SaveAppearanceSettings saveAppearanceSettings;
  final GetPosts getPosts;
  final SearchPosts searchPosts;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlogStore',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlogStoreHomePage(
        config: config,
        getPosts: getPosts,
        searchPosts: searchPosts,
        getAppearanceSettings: getAppearanceSettings,
        saveAppearanceSettings: saveAppearanceSettings,
      ),
    );
  }
}

class BlogStoreHomePage extends StatefulWidget {
  const BlogStoreHomePage({
    super.key,
    required this.config,
    required this.getPosts,
    required this.searchPosts,
    required this.getAppearanceSettings,
    required this.saveAppearanceSettings,
  });

  final AppFlavorConfig config;
  final GetPosts getPosts;
  final SearchPosts searchPosts;
  final GetAppearanceSettings getAppearanceSettings;
  final SaveAppearanceSettings saveAppearanceSettings;

  @override
  State<BlogStoreHomePage> createState() => _BlogStoreHomePageState();
}

class _BlogStoreHomePageState extends State<BlogStoreHomePage> {
  List<PostEntity> _posts = [];
  AppearanceSettingsEntity? _settings;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final postsResult = await widget.getPosts();
    final settingsResult = await widget.getAppearanceSettings(id: 1);

    setState(() {
      _posts = postsResult.valueOrNull ?? [];
      _settings = settingsResult.valueOrNull ?? const AppearanceSettingsEntity(id: 1);
      _isLoading = false;
    });
  }

  Future<void> _onSearchChanged(String query) async {
    _searchQuery = query;
    final results = await widget.searchPosts(query);
    setState(() {
      _posts = results.valueOrNull ?? [];
    });
  }

  Future<void> _toggleConsent() async {
    if (_settings == null) return;
    final updated = _settings!.copyWith(
      hasGivenConsent: !_settings!.hasGivenConsent,
    );
    await widget.saveAppearanceSettings(updated);
    setState(() {
      _settings = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.appName ?? 'BlogStore'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              label: Text(
                '${widget.config.flavor.name.toUpperCase()} (${widget.config.buildMode.name})',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.welcomeUser('User') ?? 'Welcome!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n?.postCount(_posts.length) ?? '${_posts.length} posts',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Divider(),
                        SwitchListTile(
                          title: Text(l10n?.settingsPrivacyTitle ?? 'Privacy & Consent'),
                          subtitle: Text(
                            _settings?.hasGivenConsent == true
                                ? 'Consent Granted'
                                : 'Consent Not Granted',
                          ),
                          value: _settings?.hasGivenConsent ?? false,
                          onChanged: (_) => _toggleConsent(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n?.searchSettings ?? 'Search posts...',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'Latest Articles'
                      : (l10n?.searchResults(_posts.length, _searchQuery) ??
                          '${_posts.length} results for "$_searchQuery"'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (_posts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text(
                        l10n?.noSettingsFound ?? 'No matching posts found',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ..._posts.map(
                    (post) => Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        title: Text(post.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(post.content),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'By ${post.authorName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  l10n?.readingTime(post.readTimeMinutes) ??
                                      '${post.readTimeMinutes} min read',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
