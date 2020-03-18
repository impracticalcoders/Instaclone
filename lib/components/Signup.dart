import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
@override
_SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Widget appBarTitle = new Text("AppBar Title");
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          title:appBarTitle,
          
      ),
      body: Text("hi"),
    );
  }
}