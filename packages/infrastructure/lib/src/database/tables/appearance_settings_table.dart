import 'package:drift/drift.dart';

/// Persistence table for appearance and privacy consent settings.
class AppearanceSettings extends Table {
  IntColumn get id => integer()();
  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get hasGivenConsent =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get analyticsStorageConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get adStorageConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get adUserDataConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get adPersonalizationSignalsConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get functionalityStorageConsentGranted =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get personalizationStorageConsentGranted =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get securityStorageConsentGranted =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
