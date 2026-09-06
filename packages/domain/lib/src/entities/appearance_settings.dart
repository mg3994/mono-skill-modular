/// Domain entity representing user appearance and consent preferences.
class AppearanceSettingsEntity {
  const AppearanceSettingsEntity({
    required this.id,
    this.hasCompletedOnboarding = false,
    this.hasGivenConsent = false,
    this.analyticsStorageConsentGranted = false,
    this.adStorageConsentGranted = false,
    this.adUserDataConsentGranted = false,
    this.adPersonalizationSignalsConsentGranted = false,
    this.functionalityStorageConsentGranted = true,
    this.personalizationStorageConsentGranted = false,
    this.securityStorageConsentGranted = true,
  });

  final int id;
  final bool hasCompletedOnboarding;
  final bool hasGivenConsent;
  final bool analyticsStorageConsentGranted;
  final bool adStorageConsentGranted;
  final bool adUserDataConsentGranted;
  final bool adPersonalizationSignalsConsentGranted;
  final bool functionalityStorageConsentGranted;
  final bool personalizationStorageConsentGranted;
  final bool securityStorageConsentGranted;

  AppearanceSettingsEntity copyWith({
    int? id,
    bool? hasCompletedOnboarding,
    bool? hasGivenConsent,
    bool? analyticsStorageConsentGranted,
    bool? adStorageConsentGranted,
    bool? adUserDataConsentGranted,
    bool? adPersonalizationSignalsConsentGranted,
    bool? functionalityStorageConsentGranted,
    bool? personalizationStorageConsentGranted,
    bool? securityStorageConsentGranted,
  }) {
    return AppearanceSettingsEntity(
      id: id ?? this.id,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasGivenConsent: hasGivenConsent ?? this.hasGivenConsent,
      analyticsStorageConsentGranted:
          analyticsStorageConsentGranted ?? this.analyticsStorageConsentGranted,
      adStorageConsentGranted:
          adStorageConsentGranted ?? this.adStorageConsentGranted,
      adUserDataConsentGranted:
          adUserDataConsentGranted ?? this.adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          adPersonalizationSignalsConsentGranted ??
              this.adPersonalizationSignalsConsentGranted,
      functionalityStorageConsentGranted:
          functionalityStorageConsentGranted ??
              this.functionalityStorageConsentGranted,
      personalizationStorageConsentGranted:
          personalizationStorageConsentGranted ??
              this.personalizationStorageConsentGranted,
      securityStorageConsentGranted:
          securityStorageConsentGranted ?? this.securityStorageConsentGranted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppearanceSettingsEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hasCompletedOnboarding == other.hasCompletedOnboarding &&
          hasGivenConsent == other.hasGivenConsent &&
          analyticsStorageConsentGranted ==
              other.analyticsStorageConsentGranted &&
          adStorageConsentGranted == other.adStorageConsentGranted &&
          adUserDataConsentGranted == other.adUserDataConsentGranted &&
          adPersonalizationSignalsConsentGranted ==
              other.adPersonalizationSignalsConsentGranted &&
          functionalityStorageConsentGranted ==
              other.functionalityStorageConsentGranted &&
          personalizationStorageConsentGranted ==
              other.personalizationStorageConsentGranted &&
          securityStorageConsentGranted ==
              other.securityStorageConsentGranted;

  @override
  int get hashCode => Object.hash(
        id,
        hasCompletedOnboarding,
        hasGivenConsent,
        analyticsStorageConsentGranted,
        adStorageConsentGranted,
        adUserDataConsentGranted,
        adPersonalizationSignalsConsentGranted,
        functionalityStorageConsentGranted,
        personalizationStorageConsentGranted,
        securityStorageConsentGranted,
      );
}
