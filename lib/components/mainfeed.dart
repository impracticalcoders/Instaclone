import 'dart:ffi';

import 'package:Instaclone/components/Chat/chatsPage.dart';
import 'package:Instaclone/components/Chat/myChatPage.dart';
import 'package:flutter/material.dart';
import 'postcardwidget.dart';
import 'package:http/http.dart' as http;
import 'post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyFeedPage extends StatefulWidget {
  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  List<Post> list = List();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future<FirebaseUser> getUser() async {
    return auth.currentUser();
  }

  Future<Void> fetchPosts() async {
    final response = await http.get('https://instacloneproduction.glitch.me/feed?uid=${this.user.uid}');
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
    super.initState();

    getUser().then((user) {
      if (user != null) {
        setState(() {
          this.user = user;
        });
        print('Accessing main feed as ' + user.displayName);

        fetchPosts();

        print(list.length);
      } else {
        print("not logged in");
      }
    });
  }

  void refresh() {
    fetchPosts();
    print(list.length);
  }
  AssetImage endthingdark = new AssetImage('assets/enddark.png');
  AssetImage endthinglight = new AssetImage('assets/endlight.jpg');
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
/*
    return Scaffold(
      backgroundColor: (!isDarkMode) ? Colors.white : Colors.black,
      body: Container(
        //backgroundcolor
        //color: (!isDarkMode) ? Colors.white : Colors.black,
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
                  icon:  Icon(FontAwesomeIcons.paperPlane),
                  color: dynamiciconcolor,
                  onPressed: () {Navigator.push(context, new MaterialPageRoute(builder: (context)=>
                  ChatsPage(this.user)));},
                ),
                

              ],
            ),
            SliverList(
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
                  user:this.user,
                  liked : list[index].liked,
                  username: list[index].username,
                  profileimageurl: list[index].profile_pic,
                );
              }, childCount: list.length),
            )
          ],
        ),
      ),
    );*/
    if (this.list.length==0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
    else 
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: (!isDarkMode) ? Colors.white : Colors.black,
        appBar: AppBar(
    backgroundColor: dynamicuicolor,
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
        icon: Icon(FontAwesomeIcons.paperPlane),
        color: dynamiciconcolor,
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => ChatsPage(this.user)));
        },
      ),
    ],
        ),
        body: ListView.builder(
        itemBuilder: (BuildContext context,int index){
     if (index > list.length ) return null;
     if(index==list.length){
       return (!isDarkMode) ?Image(image:endthinglight,fit: BoxFit.scaleDown,)  : Image(image:endthingdark,fit: BoxFit.scaleDown,);
       
     }
            return PostCard(
              profilename: list[index].profile_name,
              //profileimageurl: list[index].post_pic,
              postimageurl: list[index].post_pic,
              likes: list[index].likes,
              id: list[index].id,
              caption: list[index].caption,
              user:this.user,
              liked : list[index].liked,
              username: list[index].username,
              profileimageurl: list[index].profile_pic,
              scaffoldKey: this.scaffoldKey
            );
            
        },
        itemCount: list.length+1,
        physics: BouncingScrollPhysics(),
        )
      );
    }
}