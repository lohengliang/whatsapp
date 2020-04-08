import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/firebase_authentication.dart';
import 'package:whatsup/firebase_database.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() {
    return new _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController textEditingController =
      new TextEditingController();

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuthentication auth =
        Provider.of<FirebaseAuthentication>(context, listen: false);
    await auth.signOut();
  }

  Future<void> _updateDisplayName(
      BuildContext context, String displayName) async {
    final FirebaseAuthentication auth =
        Provider.of<FirebaseAuthentication>(context, listen: false);
    final user = Provider.of<User>(context);
    user.displayName = displayName;
    final database = Provider.of<FirebaseDatabase>(context, listen: false);
    await auth.updateDisplayName(displayName);
    await auth.reload();
    await database.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          actions: <Widget>[
            FlatButton(
              key: Key("logout"),
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _signOut(context),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(130.0),
            child: _buildUserInfo(user),
          ),
        ),
        body: _buildChangeDisplayName());
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
          borderColor: Colors.black54,
          borderWidth: 2.0,
        ),
        SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildChangeDisplayName() {
    return Column(children: [
      Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              autocorrect: false,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: "Enter New Display Name...",
                border: const OutlineInputBorder(),
              ),
            )),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () async {
                textEditingController.clear();
                await _updateDisplayName(context, textEditingController.text);
              },
              child: Text("Change Display Name"),
            ))
      ])
    ]);
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    @required this.photoUrl,
    @required this.radius,
    this.borderColor,
    this.borderWidth,
  });
  final String photoUrl;
  final double radius;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _borderDecoration(),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null ? Icon(Icons.camera_alt, size: radius) : null,
      ),
    );
  }

  Decoration _borderDecoration() {
    if (borderColor != null && borderWidth != null) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      );
    }
    return null;
  }
}
