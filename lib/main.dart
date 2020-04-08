import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/authentication.dart';
import 'package:whatsup/firebase_authentication.dart';
import 'package:whatsup/firebase_database.dart';
import 'package:whatsup/login.dart';
import 'package:whatsup/register.dart';
import 'package:whatsup/settings_page.dart';

void main() => runApp(MyApp(
      authenticationBuilder: (_) => FirebaseAuthentication(),
      databaseBuilder: (_, uid) => FirebaseDatabase(uid: uid),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.authenticationBuilder, this.databaseBuilder})
      : super(key: key);

  final FirebaseAuthentication Function(BuildContext context)
      authenticationBuilder;
  final FirebaseDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<FirebaseAuthentication>(
            create: authenticationBuilder,
          ),
        ],
        child: AuthenticationBuilder(
            databaseBuilder: databaseBuilder,
            builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
              return MaterialApp(
                title: 'WhatsUp',
                theme: new ThemeData(
                    primaryColor: new Color(0xff075E54),
                    accentColor: new Color(0xff25D366)),
                home: Authentication(userSnapshot: userSnapshot),
                routes: {
                  'Authentication': (context) =>
                      Authentication(userSnapshot: userSnapshot),
                  'Login': (context) => LoginPageBuilder(),
                  'Register': (context) => RegisterPageBuilder(),
                  'Settings': (context) => SettingsPage(),
                },
                debugShowCheckedModeBanner: false,
              );
            }));
  }
}
