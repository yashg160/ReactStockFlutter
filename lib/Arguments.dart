import 'dart:typed_data';

class Arguments {
  String title;
  Uint8List bytes;

  Arguments({this.title, this.bytes});

  getTitle() {
    return this.title;
  }

  getContent() {
    return this.bytes;
  }
}
