import 'package:flutter/material.dart';

class PictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context).settings.arguments.toString());
    var picture = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: Image.memory(
          picture,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
