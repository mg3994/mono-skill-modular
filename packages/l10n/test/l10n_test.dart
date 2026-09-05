import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ARB locale metadata', () {
    test('contains a valid @@locale value in every ARB file', () async {
      final arbFiles = _arbDirectory().listSync().whereType<File>().where(
        (file) => file.path.endsWith('.arb'),
      );

      expect(arbFiles, isNotEmpty);

      for (final file in arbFiles) {
        final arb =
            jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        final locale = arb['@@locale'];

        expect(
          locale,
          isA<String>().having((value) => value, 'value', isNotEmpty),
          reason: '${file.path} must declare @@locale',
        );
        expect(
          _isLocaleTag(locale as String),
          isTrue,
          reason: '${file.path} has an invalid @@locale: $locale',
        );
      }
    });

    test('accepts common locale tag forms', () {
      expect(_isLocaleTag('en'), isTrue);
      expect(_isLocaleTag('en_US'), isTrue);
      expect(_isLocaleTag('en-US'), isTrue);
      expect(_isLocaleTag('zh_Hant_TW'), isTrue);
      expect(_isLocaleTag('es-419'), isTrue);
    });

    test('does not require a particular filename convention', () {
      expect(_filenameContainsLocale('app_en.arb', 'en'), isTrue);
      expect(_filenameContainsLocale('messages_en_US.arb', 'en-US'), isTrue);
      expect(_filenameContainsLocale('translations.arb', 'en'), isFalse);
    });
  });
}

Directory _arbDirectory() {
  final packageDirectory = Directory('lib/l10n');
  if (packageDirectory.existsSync()) {
    return packageDirectory;
  }

  return Directory('packages/l10n/lib/l10n');
}

bool _isLocaleTag(String locale) {
  return RegExp(r'^[A-Za-z]{2,8}(?:[-_][A-Za-z0-9]{1,8})*$').hasMatch(locale);
}

bool _filenameContainsLocale(String filename, String locale) {
  final stem = filename.replaceFirst(RegExp(r'\.arb$'), '');
  final normalizedStem = stem.replaceAll('_', '-');
  final normalizedLocale = locale.replaceAll('_', '-');

  return RegExp('(^|-)${RegExp.escape(normalizedLocale)}(-|\$)')
      .hasMatch(normalizedStem);
}
