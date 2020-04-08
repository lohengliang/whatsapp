// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatsup/firebase_database.dart';

void main() {
  group('message from map test', () {
    // Build our app and trigger a frame.
    test('sample message', () {
      final message = Message.fromMap({
        'content': 'This is a test message.',
        'timeCreated': Timestamp.fromMillisecondsSinceEpoch(123456789),
        'userId': "ABC123",
        'displayName': "testUser123"
      }, 'id123');
      expect(
          message,
          Message(
              id: 'id123',
              content: 'This is a test message.',
              timeCreated: Timestamp.fromMillisecondsSinceEpoch(123456789),
              userId: "ABC123",
              displayName: "testUser123"));
    });
  });
}
