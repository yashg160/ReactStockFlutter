import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _loading = false;
  bool _error = false;
  String _errMessage;

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
      else {
        _errMessage = data['errorMessage'];
        throw Exception(data['errorMessage']);
      }
    } else {
      // Status code was not 200, means something was not ok. So throw an exception with ERR_SERVER
      _errMessage = 'ERR_SERVER';
      throw Exception('ERR_SERVER');
    }
  }

  saveUserData(user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('USER_ID', user.getEmail());
    await prefs.setString('USER_IMAGE', user.getImageUrl());
    await prefs.setString('USER_GIVEN_NAME', user.getGivenName());
    await prefs.setString('USER_FAMILY_NAME', user.getFamilyName());

    return;
  }

  handleSignIn(context) {
    setState(() {
      _loading = true;
      _error = false;
      _errMessage = null;
    });

    /* // The user was found and the profile was retrieved. Save some values to storage and move to main screen
      // Set the loading variable to false, to stop the modal from displaying. Then do the required actions.
      setState(() => _loading = false); */

    signInUser().then((user) => saveUserData(user)).then((response) {
      //User was found and data was saved to local storage. Move to the main screen
      print('Done');
      Navigator.pushNamedAndRemoveUntil(
          context, '/main', ModalRoute.withName(null));
    }).catchError((error) {
      // Set the loading variable to false, to stop the modal from displaying. Then do the required error handling.
      setState(() {
        _loading = false;
        _error = true;
      });
      print(error);

      //Handle the errors and pass the error message to the snackabar.

      if (_errMessage == 'ERR_FIND_USER')
        _showToast(context, 'Error in communicating with server.');
      else if (_errMessage == 'ERR_EMAIL')
        _showToast(context, 'No account found. Please try again');
      else
        _showToast(context, 'An error occurred. Please try again');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final emailFieldController = TextEditingController();

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: new Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget _mainForm(BuildContext context) {
    return (Scaffold(
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
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.left,
            ),
            Container(
              margin: EdgeInsets.only(top: 56),
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email'),
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                  controller: emailFieldController),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              width: 140,
              height: 48,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                autofocus: false,
                clipBehavior: Clip.none,
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                elevation: 24,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                onPressed: () => handleSignIn(context),
              ),
            ),
          ],
        ),
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    print(_loading);
    return (Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Builder(
          builder: (context) => ModalProgressHUD(
            child: _mainForm(context),
            inAsyncCall: _loading,
            opacity: 0.9,
            progressIndicator: CircularProgressIndicator(),
          ),
        )));
  }

  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }
}
