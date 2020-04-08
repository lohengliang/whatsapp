import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsup/firebase_authentication.dart';

class LoginPageBuilder extends StatelessWidget {
  const LoginPageBuilder({Key key, this.onSignedIn}) : super(key: key);
  final VoidCallback onSignedIn;

  static Future<void> show(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed("Login",
        arguments: LoginPageBuilder(
          onSignedIn: () => navigator.pop(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthentication auth =
        Provider.of<FirebaseAuthentication>(context, listen: false);
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(auth: auth),
      child: Consumer<LoginModel>(
        builder: (_, LoginModel model, __) =>
            LoginPage(model: model, onSignedIn: onSignedIn),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key key, @required this.model, this.onSignedIn})
      : super(key: key);
  final LoginModel model;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginModel get model => widget.model;

  Future<void> _submit() async {
    final bool success = await model.submit();
    if (success) {
      if (widget.onSignedIn != null) {
        widget.onSignedIn();
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
                onPressed: model.isLoading ? null : _submit,
                child: Text("Login"),
              ))
        ],
      ),
    );
  }
}

class LoginModel with ChangeNotifier {
  LoginModel({
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
    await auth.signInWithEmailAndPassword(email, password);
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

  void updateEmail(String email) => updateWith(email: email.trim());

  void updatePassword(String password) => updateWith(password: password.trim());
}
