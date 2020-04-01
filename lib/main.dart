import 'package:flutter/material.dart';
import 'package:whatsapp/message_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp',
      theme: new ThemeData(
          primaryColor: new Color(0xff075E54),
          accentColor: new Color(0xff25D366)),
      initialRoute: '/',
      routes: {
        '/': (context) => MessageScreen(),
      },
    );
  }
}
