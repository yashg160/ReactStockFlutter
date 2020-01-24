import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:react_stock_flutter/MainScreen.dart';
import 'package:react_stock_flutter/SignIn.dart';
import 'package:react_stock_flutter/HomeScreen.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
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

    if (id != null) {
      print(id);
      setState(() {
        isLoggedIn = true;
        userId = id;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return (MaterialApp(
        routes: <String, WidgetBuilder>{
          '/home': (context) => HomeScreen(),
          '/main': (context) => MainScreen(),
          '/signup': (context) => SignIn()
        },
        home: MainScreen(),
      ));
    } else {
      return (MaterialApp(routes: <String, WidgetBuilder>{
        '/main': (context) => MainScreen(),
        '/signup': (context) => SignIn()
      }, home: HomeScreen()));
    }
  }
}
