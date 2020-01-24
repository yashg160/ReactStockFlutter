import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('This is profile screen'),
      ),
    ));
  }
}
