import 'dart:convert';
import 'package:instaclone/services/api.dart';

import 'users.dart';
import 'package:flutter/material.dart';
import 'package:trie/trie.dart';
import 'package:http/http.dart' as http;
import 'profilesearchresultpage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<User> users;
  Widget appBarTitle = new Text("Search for users");
  Icon actionIcon = new Icon(Icons.search);
  List<String> usernames = [];
  List<String> uidlist = [];
  Trie trieusername = new Trie.list([]);

  TextEditingController searchController = new TextEditingController();

  _loadUsers() async {
    var url = Uri.parse('${api_url}/users');

    final response = await http.get(url);
    List<String> usernames = (json.decode(response.body) as List)
        .map<String>((data) => data["username"])
        .toList();
    List<User> users;
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        this.users = (json.decode(response.body) as List)
            .map((data) => new User.fromJson(data))
            .toList();
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
    setState(() {
      this.trieusername = new Trie.list(usernames);
    });
    print(this.users.length ?? 0);
  }

  _searchUsers(text) {
    setState(() {
      this.usernames = this.trieusername.getAllWordsWithPrefix(text);
    });
  }

  @override
  void initState() {
    _loadUsers();

    super.initState();
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
          title: appBarTitle,
          backgroundColor: dynamicuicolor,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextField(
                      style: new TextStyle(
                        color: dynamiciconcolor,
                      ),
                      onChanged: (text) {
                        _searchUsers(text);
                      },
                      decoration: new InputDecoration(
                        prefixIcon:
                            new Icon(Icons.search, color: dynamiciconcolor),
                        hintText: "Enter a username",
                        hintStyle: new TextStyle(color: dynamiciconcolor),
                      ),
                    );
                  } else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Search");
                  }
                });
              },
            ),
          ]),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          String resultuid;
          for (int i = 0; i < this.users.length ?? 0; i++) {
            if (this.users[i].username == this.usernames[index]) {
              print(this.users[i].uid);
              resultuid = users[i].uid;
            }
          }
          return customcontainer(
            username: this.usernames[index],
            uid: resultuid,
          );
        },
        itemCount: this.usernames.length ?? 0,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}

class customcontainer extends StatelessWidget {
  final String username;
  final String uid;
  customcontainer({
    this.username,
    this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ListTile(
        title: Text("@${this.username}"),
        onTap: () {
          print("Tapped , uid : ${this.uid}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileSearchResultPage(
                        uidretrieve: this.uid,
                      )));
        },
      ),
    );
  }
}
