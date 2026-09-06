import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAppearanceRepository implements AppearanceRepository {
  AppearanceSettingsEntity? _stored;

  @override
  Future<Result<AppearanceSettingsEntity, Failure>> getSettings(int id) async {
    return Result.success(
      _stored ?? AppearanceSettingsEntity(id: id, hasCompletedOnboarding: true),
    );
  }

  @override
  Future<Result<void, Failure>> saveSettings(
      AppearanceSettingsEntity settings) async {
    _stored = settings;
    return Result.success(null);
  }

  @override
  Stream<AppearanceSettingsEntity?> watchSettings(int id) async* {
    yield _stored ?? AppearanceSettingsEntity(id: id);
  }
}

class MockPostRepository implements PostRepository {
  final List<PostEntity> _posts = [
    PostEntity(
      id: '1',
      title: 'Clean Architecture in Dart',
      content: 'Building LEGO modules',
      authorName: 'Jules',
      publishedAt: DateTime.now(),
    ),
    PostEntity(
      id: '2',
      title: 'Flutter UI Components',
      content: 'Designing responsive interfaces',
      authorName: 'Kaisel',
      publishedAt: DateTime.now(),
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
    try {
      return Result.success(_posts.firstWhere((p) => p.id == id));
    } catch (_) {
      return Result.success(null);
    }
  }
}

void main() {
  group('Domain Layer Tests', () {
    test('GetAppearanceSettings returns settings from repository', () async {
      final repo = MockAppearanceRepository();
      final useCase = GetAppearanceSettings(repo);

      final result = await useCase(id: 1);
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.id, equals(1));
      expect(result.valueOrNull?.hasCompletedOnboarding, isTrue);
    });

    test('SaveAppearanceSettings updates repository settings', () async {
      final repo = MockAppearanceRepository();
      final getUseCase = GetAppearanceSettings(repo);
      final saveUseCase = SaveAppearanceSettings(repo);

      const updated = AppearanceSettingsEntity(
        id: 1,
        hasCompletedOnboarding: true,
        hasGivenConsent: true,
      );

      final saveResult = await saveUseCase(updated);
      expect(saveResult.isSuccess, isTrue);

      final getResult = await getUseCase(id: 1);
      expect(getResult.valueOrNull?.hasGivenConsent, isTrue);
    });

    test('SearchPosts returns filtered results based on query', () async {
      final repo = MockPostRepository();
      final searchUseCase = SearchPosts(repo);

      final allResults = await searchUseCase('');
      expect(allResults.valueOrNull?.length, equals(2));

      final filteredResults = await searchUseCase('Clean');
      expect(filteredResults.valueOrNull?.length, equals(1));
      expect(filteredResults.valueOrNull?.first.title, contains('Clean Architecture'));
    });
  });
}
