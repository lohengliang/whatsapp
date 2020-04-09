import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/firebase_authentication.dart';
import 'package:whatsup/login.dart';

class MockFirebaseAuthentication extends Mock
    implements FirebaseAuthentication {}

void main() {
  MockFirebaseAuthentication mockFirebaseAuthentication;

  setUp(() {
    mockFirebaseAuthentication = MockFirebaseAuthentication();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<FirebaseAuthentication>(
        create: (_) => mockFirebaseAuthentication,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (_) => LoginPageBuilder(
                onSignedIn: onSignedIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void mockSignInWithEmailAndPassword() {
    when(mockFirebaseAuthentication.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(User(uid: 'testUserUid')));
  }

  group('sign-in', () {
    testWidgets('user sign in', (WidgetTester tester) async {
      const email = 'tester@email.com';
      const password = 'testingpassword';

      mockSignInWithEmailAndPassword();

      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final emailField = find.byKey(Key('Email Input'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('Password Input'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // trigger frame
      await tester.pump();

      final primaryButton = find.byKey(Key('Login Button'));
      expect(primaryButton, findsOneWidget);
      await tester.tap(primaryButton);

      verify(mockFirebaseAuthentication.signInWithEmailAndPassword(
              email, password))
          .called(1);
      expect(signedIn, true);
    });
  });
}
