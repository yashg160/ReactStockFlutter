import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isLoggedIn = false;
  String userId = '';

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('USER_ID');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        userId = id;
      });
      return;
    }
  }

  Widget build(BuildContext context) {
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
      return (null);
    } else {
      return (MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('This is home screen'),
          ),
        ),
      ));
    }
  }
}

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Text('This is min screen'),
      ),
    ));
  }
}
