import 'package:firebase_auth/firebase_auth.dart';

class User {
  String uid;
  String email;
  String photoUrl;
  String displayName;

  User({this.uid, this.email, this.photoUrl, this.displayName});

  User.fromMap(Map snapshot, String id)
      : uid = snapshot['uid'] ?? '',
        email = snapshot['email'] ?? '',
        photoUrl = snapshot['photoUrl'],
        displayName = snapshot['displayName'];

  toJson() {
    return {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "displayName": displayName
    };
  }
}

class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _user(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _user(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _user(authResult.user);
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _user(user);
  }

  Future<void> updateDisplayName(String displayName) async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = displayName;
    await user.updateProfile(info);
  }

  Future<void> reload() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await user.reload();
    user = await _firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
