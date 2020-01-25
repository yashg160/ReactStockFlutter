import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:react_stock_flutter/Arguments.dart';

class PictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Arguments args = ModalRoute.of(context).settings.arguments;
    final Uint8List picture = args.getContent();
    final String title = args.getTitle();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            '$title',
            style: TextStyle(fontSize: 24),
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        body: Center(
          child: Image.memory(
            picture,
            fit: BoxFit.contain,
          ),
        ));
  }
}
