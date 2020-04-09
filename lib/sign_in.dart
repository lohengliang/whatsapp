import 'package:flutter/material.dart';
import 'package:whatsup/login.dart';
import 'package:whatsup/register.dart';

class SignInPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Whatsup",
                style: TextStyle(
                  fontSize: 40.0,
                ),
              ),
            ],
          ),
          RaisedButton(
            key: Key('Log In Button'),
            onPressed: () => LoginPageBuilder.show(context),
            child: Text("Log In"),
          ),
          RaisedButton(
            key: Key('Register Button'),
            onPressed: () => RegisterPageBuilder.show(context),
            child: Text("Register"),
          )
        ],
      ),
    );
  }
}
