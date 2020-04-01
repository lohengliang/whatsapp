import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          child: const Center(child: Text('Test A')),
        ),
        Container(
          height: 50,
          child: const Center(child: Text('Test B')),
        ),
        Container(
          height: 50,
          child: const Center(child: Text('Test C')),
        ),
      ],
    );
  }
}
