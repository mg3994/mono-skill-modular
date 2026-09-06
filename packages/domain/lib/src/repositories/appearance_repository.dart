import 'package:core/core.dart';
import '../entities/appearance_settings.dart';

/// Contract interface for persistence and retrieval of appearance settings.
abstract interface class AppearanceRepository {
  Future<Result<AppearanceSettingsEntity, Failure>> getSettings(int id);
  Future<Result<void, Failure>> saveSettings(AppearanceSettingsEntity settings);
  Stream<AppearanceSettingsEntity?> watchSettings(int id);
}
