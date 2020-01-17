import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String alert;
  bool showSpinner = false;
  bool showAlert = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
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
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  if(email != null && password != null) {
                    try {
                      setState(() {
                        showSpinner = true;
                      });
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                          email: email, password: password);
                      setState(() {
                        showSpinner = false;
                      });
                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    }
                    catch (e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                        showAlert = true;
                        alert = 'Bad Request!';
                      });
                    }
                  }
                  else
                    setState(() {
                      showAlert = true;
                      alert = 'Fill the required fields!';
                    });
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
    );
  }
}
