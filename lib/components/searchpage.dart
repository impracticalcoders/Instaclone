import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Widget appBarTitle = new Text("AppBar Title");
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          title:appBarTitle,
          actions: <Widget>[
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.white,

                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),
                  );}
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("AppBar Title");
                }


              });
            } ,),]
      ),
    );
  }
    );
  }
}
