import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:react_stock_flutter/MainScreen.dart';
import 'package:react_stock_flutter/SignIn.dart';

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
        initialRoute: '/main',
        routes: {'/main': (context) => MainScreen()},
      ));
    } else {
      return (MaterialApp(routes: <String, WidgetBuilder>{
        '/main': (context) => MainScreen(),
        '/signup': (context) => SignIn()
      }, home: HomePage()));
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/home.jpg"), fit: BoxFit.cover),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Text(
                    'ReactStock',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 42,
                        color: Colors.white),
                  ),
                  Text(
                    'Share the world around you. Through images.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  )
                ],
              ),
            ),
            RaisedButton(
              autofocus: false,
              clipBehavior: Clip.none,
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              elevation: 32,
              onPressed: () {
                Navigator.pushNamed(context, "/signup");
              },
            )
          ],
        )),
      ),
    );
  }
}
