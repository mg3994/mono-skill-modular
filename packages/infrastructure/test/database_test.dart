import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('AppDatabase', () {
    test('uses schema version 1', () {
      expect(database.schemaVersion, 1);
    });

    test('opens an executable database connection', () async {
      final result = await database
          .customSelect('SELECT 1 AS value')
          .getSingle();

      expect(result.data['value'], 1);
    });

    group('AppearanceSettings', () {
      test('inserts and retrieves settings with default values', () async {
        await database.into(database.appearanceSettings).insert(
              AppearanceSettingsCompanion.insert(
                id: const Value(1),
              ),
            );

        final settings = await (database.select(database.appearanceSettings)
              ..where((tbl) => tbl.id.equals(1)))
            .getSingle();

        expect(settings.id, 1);
        expect(settings.hasCompletedOnboarding, false);
        expect(settings.hasGivenConsent, false);
        expect(settings.functionalityStorageConsentGranted, true);
        expect(settings.securityStorageConsentGranted, true);
      });

      test('updates appearance settings values correctly', () async {
        await database.into(database.appearanceSettings).insert(
              AppearanceSettingsCompanion.insert(
                id: const Value(1),
                hasCompletedOnboarding: const Value(true),
                hasGivenConsent: const Value(true),
              ),
            );

        final initial = await (database.select(database.appearanceSettings)
              ..where((tbl) => tbl.id.equals(1)))
            .getSingle();

        expect(initial.hasCompletedOnboarding, true);
        expect(initial.hasGivenConsent, true);

        await (database.update(database.appearanceSettings)
              ..where((tbl) => tbl.id.equals(1)))
            .write(
          const AppearanceSettingsCompanion(
            analyticsStorageConsentGranted: Value(true),
          ),
        );

        final updated = await (database.select(database.appearanceSettings)
              ..where((tbl) => tbl.id.equals(1)))
            .getSingle();

        expect(updated.analyticsStorageConsentGranted, true);
      });
    });
  });
}
