import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:react_stock_flutter/MainScreen.dart';
import 'package:react_stock_flutter/SignIn.dart';
import 'package:react_stock_flutter/HomeScreen.dart';
import 'package:react_stock_flutter/ProfileScreen.dart';

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
      print('User Logged In');
      return (MaterialApp(
        theme: ThemeData(
            primaryColor: Color(0xfff2291b),
            accentColor: Colors.black.withOpacity(0.8),
            fontFamily: 'Montserrat',
            textTheme: TextTheme(
                headline: TextStyle(fontFamily: 'Montserrat'),
                title: TextStyle(fontFamily: 'Montserrat'),
                body1: TextStyle(fontFamily: 'Montserrat'),
                body2: TextStyle(fontFamily: 'Montserrat'))),
        routes: <String, WidgetBuilder>{
          '/home': (context) => HomeScreen(),
          '/main': (context) => MainScreen(),
          '/signup': (context) => SignIn(),
          '/profile': (context) => ProfileScreen()
        },
        home: MainScreen(),
      ));
    } else {
      print('User Not Logged In');
      return (MaterialApp(
          theme: ThemeData(
              primaryColor: Color(0xfff2291b),
              accentColor: Colors.black.withOpacity(0.8),
              fontFamily: 'Montserrat',
              textTheme: TextTheme(
                  headline: TextStyle(fontFamily: 'Montserrat'),
                  title: TextStyle(fontFamily: 'Montserrat'),
                  body1: TextStyle(fontFamily: 'Montserrat'),
                  body2: TextStyle(fontFamily: 'Montserrat'))),
          routes: <String, WidgetBuilder>{
            '/': (context) => HomeScreen(),
            '/main': (context) => MainScreen(),
            '/signup': (context) => SignIn(),
            '/profile': (context) => ProfileScreen()
          }));
    }
  }
}
