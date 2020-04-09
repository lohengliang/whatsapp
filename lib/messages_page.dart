import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/firebase_authentication.dart';
import 'package:whatsup/firebase_database.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() {
    return new _MessagesPageState();
  }
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: SafeArea(
            bottom: true,
            child: Stack(children: <Widget>[
              Column(children: <Widget>[
                _buildContents(context),
                _buildInput(context)
              ])
            ])));
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<FirebaseDatabase>(context, listen: false);
    return Flexible(
        child: StreamBuilder<List<Message>>(
            stream: database.fetchMessagesAsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data);
            }));
  }

  Widget _buildList(BuildContext context, List<Message> data) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
      children:
          data.map((message) => _buildListItem(context, message)).toList(),
      controller: listScrollController,
      reverse: true,
    );
  }

  Widget _buildListItem(BuildContext context, Message message) {
    final user = Provider.of<User>(context);
    if (user.uid == message.userId) {
      return _buildRightListItem(context, message);
    } else {
      return _buildLeftListItem(context, message);
    }
  }

  Widget _buildLeftListItem(BuildContext context, Message message) {
    return Row(children: <Widget>[
      Container(
        child: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                  message.displayName != null ? message.displayName : "",
                  style: TextStyle(color: Colors.blue))),
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child:
                  Text(message.content, style: TextStyle(color: Colors.black))),
          Container(
              width: 200,
              child: Text(
                  DateFormat.yMd()
                      .add_jm()
                      .format(message.timeCreated.toDate()),
                  style: TextStyle(color: Colors.grey[700]),
                  textAlign: TextAlign.right))
        ], crossAxisAlignment: CrossAxisAlignment.start),
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        width: 200.0,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
      )
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }

  Widget _buildRightListItem(BuildContext context, Message message) {
    return Container(
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(message.content,
                      style: TextStyle(color: Colors.black))),
              Container(
                  width: 200,
                  child: Text(
                      DateFormat.yMd()
                          .add_jm()
                          .format(message.timeCreated.toDate()),
                      style: TextStyle(color: Colors.grey[700]),
                      textAlign: TextAlign.right))
            ], crossAxisAlignment: CrossAxisAlignment.start),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
          )
        ], mainAxisAlignment: MainAxisAlignment.end)
      ]),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () =>
                    _addMessage(context, textEditingController.text),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(width: 0.5)),
          color: Colors.white),
    );
  }

  Future<void> _addMessage(BuildContext context, String text) async {
    final database = Provider.of<FirebaseDatabase>(context, listen: false);
    final user = Provider.of<User>(context);
    final message = Message(
        id: '',
        content: text,
        timeCreated: Timestamp.now(),
        userId: user.uid,
        displayName: user.displayName);
    textEditingController.clear();
    await database.addMessage(message.toJson());
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
