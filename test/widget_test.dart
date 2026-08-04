import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:discord/main.dart';

class TestHttpOverrides extends HttpOverrides {}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('Discord app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DiscordApp());
    await tester.pumpAndSettle();
    expect(find.text('Boot.dev - Learn to Code'), findsOneWidget);
  });
}
