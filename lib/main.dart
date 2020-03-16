 import 'package:flutter/material.dart';
import 'components/postcardwidget.dart';
import 'package:http/http.dart' as http;
import 'components/post.dart';
import 'dart:convert';
import 'dart:async';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaClone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      home: MyHomePage(title: 'InstaClone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<Post> posts;
  
  Future<Post> fetchPosts() async {
  final response = await http.get('https://insta-clone-backend.now.sh/feed');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load post');
  }
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    posts=fetchPosts();
    print(posts);
  }
  @override
  Widget build(BuildContext context) {
    
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);

    return Scaffold(
      body: Container(
        //backgroundcolor
        color: (!isDarkMode) ? Colors.white : Colors.black,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: dynamicuicolor,
              elevation: 3.0,
              centerTitle: true,
              title: Text("InstaClone",
                  style: TextStyle(
                      color: (!isDarkMode) ? Colors.black : Colors.white)),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(
                    Icons.camera_alt,
                    color: dynamiciconcolor,
                  ),
                  //onPressed: () => Scaffold.of(context).openDrawer(),
                  onPressed: () {},
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.send),
                  color: dynamiciconcolor,
                  onPressed: () {},
                )
              ],
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      // To convert this infinite list to a list with three items,
      // uncomment the following line:
      if (index > 2) return null;
      return FutureBuilder<Post>(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data.username);
                return Text(snapshot.data.username);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          );
    },),
            )
           /* SliverGrid.count(
              crossAxisCount: 1,
              children: <Widget>[
                PostCard(
                  profilename: "MKBHD",
                  postimageurl:
                      'https://magic-mark.com/wp-content/uploads/2019/10/mkbhd-intro2019-thumbnail3.jpg',
                  profileimageurl:
                      'https://pbs.twimg.com/profile_images/1212149592403382281/cI0-xyss_400x400.jpg',
                ),
                PostCard(
                  profilename: "Verge",
                ),
                PostCard(
                  profilename: "MKBHD",
                  postimageurl:
                      'https://magic-mark.com/wp-content/uploads/2019/10/mkbhd-intro2019-thumbnail3.jpg',
                  profileimageurl:
                      'https://pbs.twimg.com/profile_images/1212149592403382281/cI0-xyss_400x400.jpg',
                ),
                PostCard(
                  profilename: "Verge",
                ),
              ],
            )*/
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: dynamicuicolor,
        notchMargin: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box),
              onPressed: () {},
            )
          ],
        ),
      ),
      //drawer: Drawer(),
    );
  }
}
 
/*
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
*/