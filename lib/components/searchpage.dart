import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trie/trie.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
@override
_SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  
  Widget appBarTitle = new Text("AppBar Title");
  Icon actionIcon = new Icon(Icons.search);
  List<String> usernames = []; 
  Trie trie = new Trie.list([]);

  TextEditingController searchController = new TextEditingController();
  @override
  void initState() { 
    super.initState();
    _loadUsers();
  }

  _loadUsers()async {
    final response = await http.get('https://insta-clone-backend.now.sh/users');
    List<String> usernames = (json.decode(response.body) as List)
            .map<String>((data) => data["username"])
            .toList();
  setState(() {
        this.trie = new Trie.list(usernames);

  });
  }
  
  _searchUsers(text){
    trie.getAllWordsWithPrefix("T").toString();
    setState(() {
      this.usernames = this.trie.getAllWordsWithPrefix(text);
    });
  }
  @override
  Widget build(BuildContext context) {
        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);

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
                    onChanged: (text){_searchUsers(text);},
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white),
                        
                    ),
                  );}
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("Search...");
                }

              });
            } ,),]
      ),
      body:Container(
        //backgroundcolor
        color: (!isDarkMode) ? Colors.white : Colors.black,
        child: CustomScrollView(
          slivers: <Widget>[
           
            SliverList(
             
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return customcontainer(
                  username: this.usernames[index]
                );
              }, childCount: this.usernames.length),
            )
          ],
        ),
      ), 
    );
  }
}


class customcontainer extends StatelessWidget {
  final String username;

  customcontainer({
    this.username
  });
  
   @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
        child:ListTile(
        title:  Text(this.username),
        )
        );
  }
}
