import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/database/drift/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('AppDatabase', () {
    test('creates an empty app settings table', () async {
      final settings = await database.select(database.appSettings).get();

      expect(settings, isEmpty);
    });

    test('uses the configured defaults for app settings', () async {
      await database.into(database.appSettings).insert(
        const AppSettingsCompanion.insert(id: Value(1)),
      );

      final settings = await database.select(database.appSettings).getSingle();

      expect(settings.id, 1);
      expect(settings.hasCompletedOnboarding, isFalse);
      expect(settings.hasGivenConsent, isFalse);
      expect(settings.analyticsStorageConsentGranted, isFalse);
      expect(settings.adStorageConsentGranted, isFalse);
      expect(settings.adUserDataConsentGranted, isFalse);
      expect(settings.adPersonalizationSignalsConsentGranted, isFalse);
      expect(settings.functionalityStorageConsentGranted, isTrue);
      expect(settings.personalizationStorageConsentGranted, isFalse);
      expect(settings.securityStorageConsentGranted, isTrue);
    });

    test('persists updates to app settings', () async {
      await database.into(database.appSettings).insert(
        const AppSettingsCompanion.insert(id: Value(1)),
      );

      await (database.update(database.appSettings)
            ..where((settings) => settings.id.equals(1)))
          .write(
            const AppSettingsCompanion(
              hasCompletedOnboarding: Value(true),
              hasGivenConsent: Value(true),
            ),
          );

      final settings = await database.select(database.appSettings).getSingle();

      expect(settings.hasCompletedOnboarding, isTrue);
      expect(settings.hasGivenConsent, isTrue);
      expect(settings.functionalityStorageConsentGranted, isTrue);
    });
  });
}