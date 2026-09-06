import 'package:domain/domain.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

/// Mapper extension converting Drift database models to Domain entities and vice versa.
extension AppearanceSettingsDataX on AppearanceSetting {
  AppearanceSettingsEntity toDomain() {
    return AppearanceSettingsEntity(
      id: id,
      hasCompletedOnboarding: hasCompletedOnboarding,
      hasGivenConsent: hasGivenConsent,
      analyticsStorageConsentGranted: analyticsStorageConsentGranted,
      adStorageConsentGranted: adStorageConsentGranted,
      adUserDataConsentGranted: adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted: functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          personalizationStorageConsentGranted,
      securityStorageConsentGranted: securityStorageConsentGranted,
    );
  }
}

extension AppearanceSettingsEntityX on AppearanceSettingsEntity {
  AppearanceSettingsCompanion toCompanion() {
    return AppearanceSettingsCompanion.insert(
      id: Value(id),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
      hasGivenConsent: Value(hasGivenConsent),
      analyticsStorageConsentGranted: Value(analyticsStorageConsentGranted),
      adStorageConsentGranted: Value(adStorageConsentGranted),
      adUserDataConsentGranted: Value(adUserDataConsentGranted),
      adPersonalizationSignalsConsentGranted:
          Value(adPersonalizationSignalsConsentGranted),
      functionalityStorageConsentGranted:
          Value(functionalityStorageConsentGranted),
      personalizationStorageConsentGranted:
          Value(personalizationStorageConsentGranted),
      securityStorageConsentGranted: Value(securityStorageConsentGranted),
    );
  }
}
