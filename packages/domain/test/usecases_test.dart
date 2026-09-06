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
  });
}
