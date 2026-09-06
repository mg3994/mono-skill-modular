import 'package:core/core.dart';
import '../entities/appearance_settings.dart';
import '../repositories/appearance_repository.dart';

/// Interactor for saving user appearance settings.
final class SaveAppearanceSettings {
  const SaveAppearanceSettings(this._repository);

  final AppearanceRepository _repository;

  Future<Result<void, Failure>> call(AppearanceSettingsEntity settings) {
    return _repository.saveSettings(settings);
  }
}
