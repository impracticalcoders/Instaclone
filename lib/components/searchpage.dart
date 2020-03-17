import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title: Text("Search"),),
      body: Center(child: Text("Search")),
    );
  }
}
