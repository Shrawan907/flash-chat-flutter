import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final passwordTextController = TextEditingController();
  String email;
  String alert;
  String password;
  bool showAlert = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) =>  Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: passwordTextController,
                  textAlign: TextAlign.center,
                  obscureText: true,  // password in dots
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: "Enter your password"),
                ),
                SizedBox(
                  height: 24.0,
                ),
                !showAlert ? RoundedButton(
                  color: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPressed: () async {
                    if(email != null && password !=null) {
                      final progress = ProgressHUD.of(context);
                      try {
                        progress.show();
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        progress.dismiss();
                        passwordTextController.clear();
                        password = null;
                        if (user != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      }
                      catch (e) {
                        print(e);
                        setState(() {
                          progress.dismiss();
                          showAlert = true;
                          alert = 'Invalid user';
                        });
                      }
                    }
                    else {
                      setState(() {
                        showAlert = true;
                        alert = 'Fill the required fields';
                      });
                    }

                  },
                )
                : AlertDialog(
                    title: Text(alert),
                    actions: [FlatButton(
                      onPressed: (){setState(() {
                        showAlert = false;
                      });},
                      child: Text('Back'),
                    ),
                    ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
