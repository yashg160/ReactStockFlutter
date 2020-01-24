import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  bool _error = false;
  String _userImageUrl;
  String _userGivenName;
  String _userFamilyName;
  String _userId;

  _getDataFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('USER_ID');
    var userImageUrl = prefs.getString('USER_IMAGE');
    var userGivenName = prefs.getString('USER_GIVEN_NAME');
    var userFamilyName = prefs.getString('USER_FAMILY_NAME');

    setState(() {
      _userImageUrl = userImageUrl;
      _userId = userId;
      _userGivenName = userGivenName;
      _userFamilyName = userFamilyName;
    });

    return 'DONE';
  }

  handleGetUserData() {
    setState(() {
      _loading = true;
    });

    _getDataFromStorage().then((status) {
      print('_getDataFromStorage: DONE');
      setState(() {
        _loading = false;
      });
    }).catchError((error) {
      print(error.toString());
      setState(() {
        _loading = false;
        _error = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleGetUserData();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Builder(
        builder: (context) => ModalProgressHUD(
          inAsyncCall: _loading,
          opacity: 0.95,
          progressIndicator: CircularProgressIndicator(),
          child: Scaffold(
              body: Scaffold(
                  body: Stack(
            children: <Widget>[
              ClipPath(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                ),
                clipper: GetClipper(),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(_userImageUrl == null
                                    ? 'https://via.placeholder.com/150'
                                    : _userImageUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  color: Colors.black.withAlpha(75),
                                  spreadRadius: 8)
                            ])),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '${_userGivenName} ${_userFamilyName}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text('Some Description'),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'N',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text('PICTURES'),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      height: 56,
                      width: 180,
                      child: RaisedButton(
                        onPressed: () => print('Button Pressed'),
                        child: Text(
                          'VIEW GALLERY',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        color: Colors.red,
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(color: Colors.red)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ))),
        ),
      ),
    ));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.4);
    path.lineTo(size.width + 350, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
