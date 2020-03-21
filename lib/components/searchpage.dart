import 'dart:convert';
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
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  _loadUsers() async {
    final response = await http.get('https://insta-clone-backend.now.sh/users');
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
    print(users.length);
  }

  _searchUsers(text) {
    trieusername.getAllWordsWithPrefix("T").toString();
    setState(() {
      this.usernames = this.trieusername.getAllWordsWithPrefix(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);

    return new Scaffold(
      appBar:
          new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (text) {
                    _searchUsers(text);
                  },
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Enter a username",
                    hintStyle: new TextStyle(color: Colors.white),
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
      body: Container(
        //backgroundcolor
        color: (!isDarkMode) ? Colors.white : Colors.black,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                String resultuid;
                for(int i=0;i<this.users.length;i++){
                  if (this.users[i].username == this.usernames[index]) {
                    print(this.users[i].uid);
                    resultuid = users[i].uid;
                  }
                }
                return customcontainer(
                  username: this.usernames[index],
                  uid: resultuid,
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
         Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSearchResultPage(uidretrieve: this.uid,)));
          
        },
      ),
    );
  }
}
