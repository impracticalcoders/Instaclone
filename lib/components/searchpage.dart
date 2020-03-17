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

class SearchBar extends StatelessWidget {
  final void Function(String) onTextChange;

  SearchBar({ this.onTextChange });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: EdgeInsets.all(8),
        child: TextField(
            onChanged: onTextChange,
            decoration: InputDecoration(
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                prefixIcon: Icon(Icons.search),
                hintText: 'Search something ...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero
            )
        )
    );
  }
}