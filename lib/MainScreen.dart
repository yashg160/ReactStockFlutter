import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool _loading = true;
  bool _error = false;
  String _errMessage = '';
  List _pictures = [];
  BuildContext _context;

  _getPictures() async {
    var response = await http.get('http://10.102.113.91:8000/picture?num=10');

    if (response.statusCode == 200) {
      // If everything is correct, convert the data to json and check for error
      var data = await convert.jsonDecode(response.body);

      // If error, then throw an exception, which will be handled by the calling function
      if (data['error']) {
        _errMessage = data['errorMessage'];
        throw Exception(data['errorMessage']);
      }

      // There was no error. Then extract the image data from the response.
      var pictures = data['pictures'];
      return pictures;
    } else {
      // Some error occurred. Throw Exception to handle in the calling function
      _errMessage = 'ERR_SERVER';
      throw Exception('ERR_SERVER');
    }
  }

  _handleGetPictures() {
    setState(() {
      _loading = true;
      _error = false;
      _errMessage = '';
    });

    _getPictures().then((pictures) {
      setState(() {
        _pictures = pictures;
        _loading = false;
        _error = false;
      });

      print(_pictures.length);
    }).catchError((error) {
      setState(() {
        _loading = false;
        _error = true;
      });
      print(error.toString());

      // Based on the state _errorMessage, show the snackbar with appropriate message

      if (_errMessage == 'ERR_PICTURES')
        _showToast(_context, 'Error in communicating with server.');
      else
        _showToast(_context, 'An error occurred. Please try again');
    });
  }

  @override
  void initState() {
    super.initState();
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

  Widget _mainContent(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Text('This is min screen'),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _handleGetPictures();
    return (Scaffold(
        body: Builder(
      builder: (context) => ModalProgressHUD(
        child: _mainContent(context),
        inAsyncCall: _loading,
        opacity: 0.9,
        progressIndicator: CircularProgressIndicator(),
      ),
    )));
  }
}
