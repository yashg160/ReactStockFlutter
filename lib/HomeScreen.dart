import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/home.jpg"),
                      fit: BoxFit.cover)),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              left: MediaQuery.of(context).size.width / 8,
              right: MediaQuery.of(context).size.width / 8,
              child: Column(
                children: <Widget>[
                  Text(
                    'ReactStock',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Share the world around you. Through pictures.',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 72,
                  ),
                  Container(
                    height: 48,
                    width: 140,
                    child: RaisedButton(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 24,
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                    ),
                  ),
                  SizedBox(
                    height: 144,
                  ),
                  Text('Photo by Ilya Plakhuta on Unsplash',
                      style: TextStyle(color: Colors.white, fontSize: 14))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
