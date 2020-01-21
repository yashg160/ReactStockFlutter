import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Sign In Screen'),
      ),
      body: Center(
        child: Text('This is sign in screen'),
      ),
    ));
  }
}
