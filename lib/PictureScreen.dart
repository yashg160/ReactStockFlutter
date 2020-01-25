import 'package:flutter/material.dart';
import 'package:react_stock_flutter/Arguments.dart';

class PictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Arguments args = ModalRoute.of(context).settings.arguments;
    print(args.getTitle());
    print(args.getContent());
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      /* body: Center(
        child: Image.memory(
          picture,
          fit: BoxFit.contain,
        ),
      ), */
    );
  }
}
