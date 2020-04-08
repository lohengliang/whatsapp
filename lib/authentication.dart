import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/firebase_authentication.dart';
import 'package:whatsup/firebase_database.dart';
import 'package:whatsup/home_page.dart';
import 'package:whatsup/sign_in.dart';

class AuthenticationBuilder extends StatelessWidget {
  const AuthenticationBuilder(
      {Key key, @required this.builder, @required this.databaseBuilder})
      : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;
  final FirebaseDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  @override
  Widget build(BuildContext context) {
    final authentication =
        Provider.of<FirebaseAuthentication>(context, listen: false);
    return StreamBuilder<User>(
      stream: authentication.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        final User user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<User>.value(value: user),
              Provider<FirebaseDatabase>(
                create: (context) => databaseBuilder(context, user.uid),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}

class Authentication extends StatelessWidget {
  const Authentication({Key key, @required this.userSnapshot})
      : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePage() : SignInPage();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
