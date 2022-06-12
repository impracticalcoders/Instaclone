import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:instaclone/components/Chat/chatsPage.dart';
import 'package:instaclone/services/api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'post.dart';
import 'postcardwidget.dart';

class MyFeedPage extends StatefulWidget {
  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  List<Post> list = List();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  User getUser() {
    return auth.currentUser;
  }

  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('${api_url}/feed?uid=${this.user.uid}'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        this.list = (json.decode(response.body) as List).map((data) {
          print(data);
          return new Post.fromJson(data);
        }).toList();
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

    var user = getUser();
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
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    // monitor network fetch
    await refresh();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  Future<void> refresh() async {
    await fetchPosts();
    setState(() {
      ;
    });
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
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(
            waterDropColor: dynamicuicolor,
          ),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("pull up load");
              } else if (mode == LoadStatus.loading) {
                body = CircularProgressIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (index > list.length) return null;
              if(list.length==0){
                return Center(
                  child: Text("No posts from your followees yet"),
                );
              }
              if (index == list.length) {
                return (!isDarkMode)
                    ? Image(
                        image: endthinglight,
                        fit: BoxFit.scaleDown,
                      )
                    : Image(
                        image: endthingdark,
                        fit: BoxFit.scaleDown,
                      );
              }
              return PostCard(
                  profilename: list[index].profile_name,
                  //profileimageurl: list[index].post_pic,
                  postimageurl: list[index].image_url,
                  likes: list[index].likes,
                  id: list[index].id,
                  caption: list[index].caption,
                  user: this.user,
                  liked: list[index].liked,
                  username: list[index].username,
                  profileimageurl: list[index].profile_pic,
                  scaffoldKey: this.scaffoldKey);
            },
            itemCount: list.length + 1,
            physics: BouncingScrollPhysics(),
          )),
    );
  }
}
