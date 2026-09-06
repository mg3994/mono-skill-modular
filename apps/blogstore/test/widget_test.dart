import 'package:blogstore/main.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAppearanceRepository implements AppearanceRepository {
  AppearanceSettingsEntity _settings = const AppearanceSettingsEntity(id: 1);

  @override
  Future<Result<AppearanceSettingsEntity, Failure>> getSettings(int id) async {
    return Result.success(_settings);
  }

  @override
  Future<Result<void, Failure>> saveSettings(
      AppearanceSettingsEntity settings) async {
    _settings = settings;
    return Result.success(null);
  }

  @override
  Stream<AppearanceSettingsEntity?> watchSettings(int id) async* {
    yield _settings;
  }
}

class MockPostRepository implements PostRepository {
  final List<PostEntity> _posts = [
    PostEntity(
      id: '1',
      title: 'Modular LEGO Architecture Test',
      content: 'Testing Clean Arch in BlogStore',
      authorName: 'Jules',
      publishedAt: DateTime.now(),
      readTimeMinutes: 3,
    ),
    PostEntity(
      id: '2',
      title: 'Flutter UI Components',
      content: 'Building user interface',
      authorName: 'Kaisel',
      publishedAt: DateTime.now(),
      readTimeMinutes: 2,
    ),
  ];

  @override
  Future<Result<List<PostEntity>, Failure>> getPosts() async {
    return Result.success(_posts);
  }

  @override
  Future<Result<List<PostEntity>, Failure>> searchPosts(String query) async {
    final filtered = _posts
        .where((p) =>
            p.title.toLowerCase().contains(query.toLowerCase()) ||
            p.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Result.success(filtered);
  }

  @override
  Future<Result<PostEntity?, Failure>> getPostById(String id) async {
    return Result.success(null);
  }
}

void main() {
  testWidgets('BlogStoreApp renders main screen and supports post search',
      (WidgetTester tester) async {
    const config = AppFlavorConfig(
      flavor: Flavor.development,
      buildMode: BuildMode.debug,
    );
    final appearanceRepo = MockAppearanceRepository();
    final postRepo = MockPostRepository();

    await tester.pumpWidget(
      BlogStoreApp(
        config: config,
        getAppearanceSettings: GetAppearanceSettings(appearanceRepo),
        saveAppearanceSettings: SaveAppearanceSettings(appearanceRepo),
        getPosts: GetPosts(postRepo),
        searchPosts: SearchPosts(postRepo),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('BlogStore'), findsOneWidget);
    expect(find.text('Modular LEGO Architecture Test'), findsOneWidget);
    expect(find.text('Flutter UI Components'), findsOneWidget);

    // Enter search query
    await tester.enterText(find.byType(TextField), 'LEGO');
    await tester.pumpAndSettle();

    expect(find.text('Modular LEGO Architecture Test'), findsOneWidget);
    expect(find.text('Flutter UI Components'), findsNothing);
  });
}
