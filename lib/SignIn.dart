import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UserProfile {
  final String givenName;
  final String familyName;
  final String imageUrl;
  final String email;

  UserProfile({this.givenName, this.familyName, this.imageUrl, this.email});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
      givenName: json['givenName'],
      familyName: json['familyName'],
      imageUrl: json['imageUrl'],
      email: json['email']);

  String getGivenName() {
    return '${this.givenName}';
  }

  String getFamilyName() {
    return '${this.familyName}';
  }

  String getEmail() {
    return '${this.email}';
  }

  String getImageUrl() {
    return '${this.imageUrl}';
  }
}

class SignIn extends StatefulWidget {
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool loading = false;
  bool error = false;
  String errMessage;

  signInUser() async {
    //Get the data from the API
    var response = await http.get(
        'http://10.102.113.91:8000/user?email=${emailFieldController.text}');

    if (response.statusCode == 200) {
      // If everything is correct, convert the data to json and check for error
      var data = await convert.jsonDecode(response.body);

      // If error, then throw an exception, which will be handled by the calling function
      if (!data['error'])
        return UserProfile.fromJson(data['profile']);
      else
        throw Exception(data['errorMessage']);
    } else {
      // Status code was not 200, means something was not ok. So throw an exception with ERR_SERVER
      throw Exception('ERR_SERVER');
    }
  }

  handleSignIn() {
    setState(() {
      loading = true;
      error = false;
      errMessage = null;
    });

    signInUser().then((user) {
      print(user.getFamilyName());
      print(user.getGivenName());
      print(user.getImageUrl());
      print(user.getEmail());
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final emailFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.only(top: 48, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Text(
              'Please enter the email you used to register with us',
            ),
            Container(
              margin: EdgeInsets.only(top: 64),
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email'),
                  style: TextStyle(fontSize: 24),
                  controller: emailFieldController),
            ),
            Container(
              margin: EdgeInsets.only(top: 32),
              child: RaisedButton(
                autofocus: false,
                clipBehavior: Clip.none,
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                elevation: 32,
                onPressed: () => handleSignIn(),
              ),
            )
          ],
        ),
      )),
    ));
  }

  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }
}
