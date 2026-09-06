import 'package:core/core.dart';
import '../entities/appearance_settings.dart';
import '../repositories/appearance_repository.dart';

/// Interactor for retrieving user appearance settings.
final class GetAppearanceSettings {
  const GetAppearanceSettings(this._repository);

  final AppearanceRepository _repository;

  Future<Result<AppearanceSettingsEntity, Failure>> call({int id = 1}) {
    return _repository.getSettings(id);
  }
}
