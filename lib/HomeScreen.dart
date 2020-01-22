import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatelessWidget {
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
