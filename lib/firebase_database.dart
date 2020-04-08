import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsup/firebase_authentication.dart';

class FirebaseDatabase {
  FirebaseDatabase({this.uid});
  String uid;
  CollectionReference messagesRef =
      Firestore.instance.collection('chats/main/messages');

  Future<List<Message>> fetchMessages() async {
    final firebaseMessages = await messagesRef.getDocuments();
    return firebaseMessages.documents
        .map((doc) => Message.fromMap(doc.data, doc.documentID))
        .toList();
  }

  Stream<List<Message>> fetchMessagesAsStream() {
    final Stream<QuerySnapshot> snapshots =
        messagesRef.orderBy('timeCreated', descending: false).snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.documents
          .map(
              (snapshot) => Message.fromMap(snapshot.data, snapshot.documentID))
          .where((value) => value != null)
          .toList();
      return result;
    });
  }

  Future<Message> getMessageById(String id) async {
    final doc = await messagesRef.document(id).get();
    return Message.fromMap(doc.data, doc.documentID);
  }

  Future<void> removeMessage(String id) {
    return messagesRef.document(id).delete();
  }

  Future<void> addMessage(Map data) async {
    return messagesRef.add(data);
  }

  Future<User> getUserByUid(String uid) async {
    final reference = Firestore.instance.document('chats/main/users/$uid');
    final doc = await reference.get();
    return User.fromMap(doc.data, doc.documentID);
  }

  Future<void> setUser(User user) async {
    final reference = Firestore.instance.document('chats/main/users/$uid');
    await reference.setData(
      user.toJson(),
    );
  }
}

class Message {
  final String id;
  final String content;
  final Timestamp timeCreated;
  final String userId;
  final String displayName;

  Message(
      {this.id, this.content, this.timeCreated, this.userId, this.displayName});

  Message.fromMap(Map snapshot, String id)
      : id = id ?? '',
        content = snapshot['content'] ?? '',
        timeCreated = snapshot['timeCreated'],
        userId = snapshot['userId'],
        displayName = snapshot['displayName'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID);

  toJson() {
    return {
      "content": content,
      "timeCreated": timeCreated,
      "userId": userId,
      "displayName": displayName
    };
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Message otherMessage = other;
    return id == otherMessage.id &&
        content == otherMessage.content &&
        timeCreated == otherMessage.timeCreated &&
        userId == otherMessage.userId &&
        displayName == otherMessage.displayName;
  }
}
