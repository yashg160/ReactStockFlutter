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
  bool _isLoggedIn = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    handleAutoLogin();
  }

  _autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('USER_ID');

    if (id != null) {
      print(id);
      return id;
    } else if (id == null)
      throw Exception('ERR_NULL_USER_ID');
    else
      throw Exception('ERR_UNKNOWN');
  }

  handleAutoLogin() {
    _autoLogIn().then((id) {
      print(id);
      setState(() {
        _loading = false;
        _isLoggedIn = true;
      });
      print('Log In Resolved');
    }).catchError((onError) {
      print('Main Error: $onError');
      setState(() {
        _loading = false;
        _isLoggedIn = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return (Center(
        child: CircularProgressIndicator(),
      ));
    } else if (_isLoggedIn) {
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
          '/home': (context) => HomeScreen(),
          '/main': (context) => MainScreen(),
          '/signup': (context) => SignIn(),
          '/profile': (context) => ProfileScreen()
        },
        home: HomeScreen(),
      ));
    }
  }
}
