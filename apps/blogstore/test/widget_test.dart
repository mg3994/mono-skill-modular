import 'package:blogstore/main.dart';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
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
  @override
  Future<Result<List<PostEntity>, Failure>> getPosts() async {
    return Result.success([
      PostEntity(
        id: '1',
        title: 'Modular LEGO Architecture Test',
        content: 'Testing Clean Arch in BlogStore',
        authorName: 'Jules',
        publishedAt: DateTime.now(),
        readTimeMinutes: 3,
      ),
    ]);
  }

  @override
  Future<Result<PostEntity?, Failure>> getPostById(String id) async {
    return Result.success(null);
  }
}

void main() {
  testWidgets('BlogStoreApp renders main screen with posts and settings',
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
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('BlogStore'), findsOneWidget);
    expect(find.text('Modular LEGO Architecture Test'), findsOneWidget);
  });
}
