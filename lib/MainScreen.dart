import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:react_stock_flutter/Arguments.dart';

class Picture {
  String title;
  String base64;
  String id;
  Uint8List bytes;

  Picture({this.id, this.title, this.base64, this.bytes});

  getTitle() {
    return this.title;
  }

  getContent() {
    return this.bytes;
  }

  getId() {
    return this.id;
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.action});

  String title;
  String action;
}

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool _loading = true;
  bool _error = false;
  String _errMessage = '';
  List _pictures = [];

  _getPictures() async {
    var response = await http.get('http://10.102.113.91:8000/picture?num=2');

    if (response.statusCode == 200) {
      // If everything is correct, convert the data to json and check for error
      var data = await convert.jsonDecode(response.body);

      // If error, then throw an exception, which will be handled by the calling function
      if (data['error']) {
        _errMessage = data['errorMessage'];
        throw Exception(data['errorMessage']);
      }

      // There was no error. Then extract the image data from the response.
      List pictures = data['pictures'];
      return pictures;
    } else {
      // Some error occurred. Throw Exception to handle in the calling function
      _errMessage = 'ERR_SERVER';
      throw Exception('ERR_SERVER');
    }
  }

  _getImagesFromBase64(pictures) async {
    // Pictures is an array containing pictures encoded as base64 images, along with their titles and id.
    // The class Picture handles the conversion to bit-array and other stuff. Create Picture objects and return an array.

    List finalPictures = [];

    for (var pic in pictures) {
      String content = pic['content'];
      String base64String = content.split(',')[1];

      Uint8List bytes = convert.base64Decode(base64String);
      Picture picture = new Picture(
          id: pic['_id'],
          title: pic['title'],
          base64: base64String,
          bytes: bytes);

      _pictures.add(picture);
    }

    return finalPictures;
  }

  _handleGetPictures() {
    setState(() {
      _loading = true;
      _error = false;
      _errMessage = '';
    });

    _getPictures().then((pictures) {
      if (pictures.length == 0) {
        _errMessage = 'ERR_NO_PICTURES';
        throw Exception('ERR_NO_PICTURES');
      }
      _getImagesFromBase64(pictures);
    }).then((finalPictures) {
      setState(() {
        _loading = false;
        _error = false;
      });
      print('Pictures Retrieved');
    }).catchError((error) {
      setState(() {
        _loading = false;
        _error = true;
      });
      print(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _handleGetPictures();
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: new Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'Sign Out', action: 'ACTION_SIGN_OUT'),
    CustomPopupMenu(title: 'My Profile', action: 'ACTION_PROFILE')
  ];

  signUserOut(CustomPopupMenu choice, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('USER_ID');
    await prefs.remove('USER_IMAGE');
    await prefs.remove('USER_GIVEN_NAME');
    await prefs.remove('USER_FAMILY_NAME');

    print(choice.action);
    return 'DONE';
  }

  void _handleChoiceSelect(CustomPopupMenu choice, BuildContext context) {
    if (choice.action == 'ACTION_SIGN_OUT') {
      signUserOut(choice, context).then((status) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', ModalRoute.withName(null));
      }).catchError((error) {
        print(error.toString());
      });
    } else if (choice.action == 'ACTION_PROFILE') {
      Navigator.pushNamed(context, '/profile');
    }
  }

  handlePictureTap(BuildContext context, Picture picture) {
    print('Picture Tapped');

    Arguments args =
        new Arguments(title: picture.getTitle(), bytes: picture.getContent());

    Navigator.of(context).pushNamed('/picture', arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      _showToast(context, 'An error occurred');
      return (Scaffold(
        appBar: AppBar(
          title: Text('ReactStock'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: RaisedButton(
                  child: Text('RETRY'),
                  autofocus: false,
                  clipBehavior: Clip.none,
                  elevation: 24,
                  onPressed: () {
                    print('Retry Pressed');
                  },
                ),
              ),
              Container(
                child: Text('An error occurred. Please try again.'),
              )
            ],
          ),
        ),
      ));
    } else {
      return (Scaffold(
        body: Builder(
          builder: (context) => ModalProgressHUD(
            inAsyncCall: _loading,
            opacity: 0.9,
            progressIndicator: CircularProgressIndicator(),
            child: Scaffold(
              appBar: AppBar(
                title: Text('ReactStock'),
                actions: <Widget>[
                  PopupMenuButton<CustomPopupMenu>(
                    elevation: 8,
                    onCanceled: () => print('Selection cancelled'),
                    tooltip: 'This is the tooltip',
                    onSelected: (choice) =>
                        _handleChoiceSelect(choice, context),
                    itemBuilder: (BuildContext contextSome) {
                      return choices.map((CustomPopupMenu choice) {
                        return PopupMenuItem<CustomPopupMenu>(
                          value: choice,
                          child: Text(choice.title),
                        );
                      }).toList();
                    },
                  )
                ],
              ),
              body: ListView(
                children: [
                  Container(
                    child: Text(
                      'Recommended for you',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    margin: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                  ),
                  Column(
                    children: _pictures.map((picture) {
                      return InkWell(
                          onTap: () => handlePictureTap(context, picture),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 280,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    child: Image.memory(picture.getContent(),
                                        fit: BoxFit.fill),
                                    elevation: 12,
                                  ),
                                ),
                                Container(
                                  child: Text(picture.getTitle(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                  margin: EdgeInsets.only(top: 12, bottom: 16),
                                ),
                              ],
                            ),
                          ));
                    }).toList(),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    height: 48,
                    padding: EdgeInsets.only(right: 96, left: 96),
                    child: RaisedButton(
                      onPressed: () => _handleGetPictures(),
                      child: Text(
                        'LOAD MORE',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    }
  }
}
