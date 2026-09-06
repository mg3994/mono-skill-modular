import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../mappers/appearance_settings_mapper.dart';

/// Drift database implementation of [AppearanceRepository].
final class DriftAppearanceRepository implements AppearanceRepository {
  const DriftAppearanceRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<AppearanceSettingsEntity, Failure>> getSettings(int id) async {
    try {
      final query = _database.select(_database.appearanceSettings)
        ..where((tbl) => tbl.id.equals(id));
      final result = await query.getSingleOrNull();

      if (result == null) {
        // Return default entity if not present yet
        return Result.success(AppearanceSettingsEntity(id: id));
      }
      return Result.success(result.toDomain());
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to load appearance settings', '$e\n$st'),
      );
    }
  }

  @override
  Future<Result<void, Failure>> saveSettings(
      AppearanceSettingsEntity settings) async {
    try {
      await _database
          .into(_database.appearanceSettings)
          .insertOnConflictUpdate(settings.toCompanion());
      return Result.success(null);
    } catch (e, st) {
      return Result.failure(
        DatabaseFailure('Failed to save appearance settings', '$e\n$st'),
      );
    }
  }

  @override
  Stream<AppearanceSettingsEntity?> watchSettings(int id) {
    final query = _database.select(_database.appearanceSettings)
      ..where((tbl) => tbl.id.equals(id));
    return query
        .watchSingleOrNull()
        .map((data) => data?.toDomain() ?? AppearanceSettingsEntity(id: id));
  }
}
