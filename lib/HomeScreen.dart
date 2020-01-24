import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'ReactStock',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Share the world around you. Through pictures.',
                style: TextStyle(fontSize: 22, color: Colors.white),
                textAlign: TextAlign.center,
              ),
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
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 24,
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}
