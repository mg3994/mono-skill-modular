import 'package:domain/domain.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';

void main() {
  group('Infrastructure Layer Tests', () {
    late AppDatabase db;
    late DriftAppearanceRepository appearanceRepo;
    late InMemoryPostRepository postRepo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      appearanceRepo = DriftAppearanceRepository(db);
      postRepo = InMemoryPostRepository();
    });

    tearDown(() async {
      await db.close();
    });

    test('DriftAppearanceRepository saves and retrieves settings', () async {
      const entity = AppearanceSettingsEntity(
        id: 1,
        hasCompletedOnboarding: true,
        hasGivenConsent: true,
      );

      final saveResult = await appearanceRepo.saveSettings(entity);
      expect(saveResult.isSuccess, isTrue);

      final getResult = await appearanceRepo.getSettings(1);
      expect(getResult.isSuccess, isTrue);
      final loaded = getResult.valueOrNull;
      expect(loaded, isNotNull);
      expect(loaded?.hasCompletedOnboarding, isTrue);
      expect(loaded?.hasGivenConsent, isTrue);
    });

    test('InMemoryPostRepository returns sample posts', () async {
      final postsResult = await postRepo.getPosts();
      expect(postsResult.isSuccess, isTrue);
      expect(postsResult.valueOrNull, isNotEmpty);

      final singleResult = await postRepo.getPostById('1');
      expect(singleResult.isSuccess, isTrue);
      expect(singleResult.valueOrNull?.title, contains('Modular'));
    });
  });
}
