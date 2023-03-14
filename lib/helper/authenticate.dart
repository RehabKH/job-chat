

import 'package:flutter/material.dart';
import 'package:medical_chat_group/services/notification.dart';
import 'package:medical_chat_group/views/signIn.dart';
import 'package:medical_chat_group/views/signUp.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleAuth() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }
  @override
  Widget build(BuildContext context) {
    return (showSignIn) ? SignIn(toggleAuth) : SignUp(toggleAuth);
  }
}
