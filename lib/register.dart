import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/firebase_authentication.dart';

class RegisterPageBuilder extends StatelessWidget {
  const RegisterPageBuilder({Key key, this.onRegistered}) : super(key: key);
  final VoidCallback onRegistered;

  static Future<void> show(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed("Register",
        arguments: RegisterPageBuilder(
          onRegistered: () => navigator.pop(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthentication auth =
        Provider.of<FirebaseAuthentication>(context, listen: false);
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(auth: auth),
      child: Consumer<RegisterModel>(
        builder: (_, RegisterModel model, __) =>
            RegisterPage(model: model, onRegistered: onRegistered),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key, @required this.model, this.onRegistered})
      : super(key: key);
  final RegisterModel model;
  final VoidCallback onRegistered;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterModel get model => widget.model;

  Future<void> _submit() async {
    final bool success = await model.submit();
    if (success) {
      if (widget.onRegistered != null) {
        widget.onRegistered();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsUp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: model.updateEmail,
                decoration: InputDecoration(
                  hintText: "Enter Your Email...",
                  border: const OutlineInputBorder(),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                obscureText: true,
                onChanged: model.updatePassword,
                decoration: InputDecoration(
                  hintText: "Enter Your Password...",
                  border: const OutlineInputBorder(),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () async {
                  await _submit();
                },
                child: Text("Register"),
              ))
        ],
      ),
    );
  }
}

class RegisterModel with ChangeNotifier {
  RegisterModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
  });

  String email;
  String password;
  bool isLoading;
  bool submitted;

  final FirebaseAuthentication auth;

  Future<bool> submit() async {
    updateWith(submitted: true, isLoading: true);
    await auth.createUserWithEmailAndPassword(email, password);
    return true;
  }

  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);
}
