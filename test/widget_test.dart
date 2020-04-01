// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp/main.dart';

void main() {
  testWidgets('MyApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that title 'WhatsApp' exists
    expect(find.text('WhatsApp'), findsOneWidget);

    // Verify that the texts 'Message' and 'Settings' exists
    expect(find.text('Message'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
