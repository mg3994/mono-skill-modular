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
    test('uses schema version 1', () {
      expect(database.schemaVersion, 1);
    });

    test('opens an executable database connection', () async {
      final result = await database
          .customSelect('SELECT 1 AS value')
          .getSingle();

      expect(result.data['value'], 1);
    });
  });
}
