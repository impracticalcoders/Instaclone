import 'package:flutter/material.dart';

class CreditsPage extends StatefulWidget {
@override
_CreditsPageState createState() => new _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  Widget appBarTitle = new Text("Credits");
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