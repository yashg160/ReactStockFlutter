import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
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
                          image:
                              NetworkImage('https://via.placeholder.com/150'),
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
                'Yash Gupta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
    )));
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
