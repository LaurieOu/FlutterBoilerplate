import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../scoped-models/user_repository.dart';
import './../../models/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: '');
    _password = TextEditingController(text: '');
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _email,
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter Email";
        } else if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      style: style,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: "Email",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _password,
      validator: (value) => (value.isEmpty) ? "Please Enter Password" : null,
      style: style,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: "Password",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSignInButton(user) {
    return MaterialButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          if (!await user.authenticate(_email.text, _password.text, AuthMode.Login)) {
            _key.currentState.showSnackBar(SnackBar(
              content: Text("Something is wrong"),
            ));
          }
        }
      },
      child: Text(
        "Sign In",
        style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget _buildGoogleSignInButton(user) {
  //   return MaterialButton(
  //     onPressed: () async {
  //       if (!await user.signInWithGoogle())
  //         _key.currentState.showSnackBar(SnackBar(
  //           content: Text("Something is wrong"),
  //         ));
  //     },
  //     child: Text(
  //       "Sign In With Google",
  //       style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Toastmasters"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildEmailTextField(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildPasswordTextField(),
              ),
              user.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red,
                        child: _buildSignInButton(user),
                      ),
                    ),
              SizedBox(height: 20),
              // user.status == Status.Authenticating
              //     ? Center(child: CircularProgressIndicator())
              //     : Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //         child: Material(
              //           elevation: 5.0,
              //           borderRadius: BorderRadius.circular(30.0),
              //           color: Colors.red,
              //           child: _buildGoogleSignInButton(user),
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
