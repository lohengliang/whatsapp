import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/firebase_authentication.dart';
import 'package:whatsup/login.dart';
import 'package:whatsup/register.dart';
import 'package:whatsup/sign_in.dart';

class MockFirebaseAuthentication extends Mock
    implements FirebaseAuthentication {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  MockFirebaseAuthentication mockFirebaseAuthentication;
  MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockFirebaseAuthentication = MockFirebaseAuthentication();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  testWidgets('sign in page navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
          providers: [
            Provider<FirebaseAuthentication>(
              create: (_) => mockFirebaseAuthentication,
            ),
          ],
          child: MaterialApp(
            home: SignInPage(),
            routes: {
              'Login': (_) => LoginPageBuilder(),
              'Register': (_) => RegisterPageBuilder(),
            },
            navigatorObservers: [mockNavigatorObserver],
          )),
    );

    verify(mockNavigatorObserver.didPush(any, any)).called(1);

    final loginButton = find.byKey(Key('Log In Button'));
    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });

  testWidgets('sign in page navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
          providers: [
            Provider<FirebaseAuthentication>(
              create: (_) => mockFirebaseAuthentication,
            ),
          ],
          child: MaterialApp(
            home: SignInPage(),
            routes: {
              'Login': (_) => LoginPageBuilder(),
              'Register': (_) => RegisterPageBuilder(),
            },
            navigatorObservers: [mockNavigatorObserver],
          )),
    );

    verify(mockNavigatorObserver.didPush(any, any)).called(1);

    final registerButton = find.byKey(Key('Register Button'));
    expect(registerButton, findsOneWidget);

    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });
}
