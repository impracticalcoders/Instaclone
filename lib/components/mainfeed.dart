import 'package:flutter/material.dart';
import 'postcardwidget.dart';
import 'package:http/http.dart' as http;
import 'post.dart';
import 'dart:convert';
import 'dart:async';

class MyFeedPage extends StatefulWidget {
  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  List<Post> list = List();

  Future<Post> fetchPosts() async {
    final response = await http.get('https://insta-clone-backend.now.sh/feed');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        this.list = (json.decode(response.body) as List)
            .map((data) => new Post.fromJson(data))
            .toList();
      });
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
    fetchPosts();
    print(list.length);
  }

  void refresh() {
    fetchPosts();
    print(list.length);
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
              title: Text("Instaclone",
                  style: TextStyle(
                      color: (!isDarkMode) ? Colors.black : Colors.white,
                      fontFamily: 'Billabong',
                      fontSize: 30)),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(
                    Icons.refresh,
                    color: dynamiciconcolor,
                  ),
                  //onPressed: () => Scaffold.of(context).openDrawer(),
                  onPressed: () {
                    refresh();
                  },
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
            SliverList(/*
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),*/
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                if (index > list.length - 1) return null;
                return PostCard(
                  profilename: list[index].profile_name,
                  //profileimageurl: list[index].post_pic,
                  postimageurl: list[index].post_pic,
                  likes: list[index].likes,
                  id: list[index].id,
                  caption: list[index].caption,
                );
              }, childCount: list.length),
            )
          ],
        ),
      ),
    );
  }
}
