import 'package:blogstore/main.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';

void main() {
  testWidgets('BlogStoreApp loads and renders app title and welcome message',
      (WidgetTester tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(BlogStoreApp(database: database));
    await tester.pumpAndSettle();

    expect(find.text('BlogStore'), findsOneWidget);
    expect(find.text('Welcome back, Reader!'), findsOneWidget);

    await database.close();
  });
}
