import 'dart:ffi'; //for future<void>
import 'package:flutter/cupertino.dart';
import 'package:Instaclone/components/privatepostcardwidget.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'mainfeed.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'userdetails.dart';
import 'privatepostcardwidget.dart';

class ProfileSearchResultPage extends StatefulWidget {
  String uidretrieve;
  @override
  ProfileSearchResultPage({
    this.uidretrieve,
  });
  @override
  _ProfileSearchResultPageState createState() =>
      _ProfileSearchResultPageState();
}

class _ProfileSearchResultPageState extends State<ProfileSearchResultPage> {
  int newlength;
  Userdetails userdata;

  Future<Void> fetchPosts() async {
    print("function called");
    final response = await http.get(
        'https://instacloneproduction.glitch.me/user_details?uid=${this.widget.uidretrieve}');
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        this.userdata =
            Userdetails.fromJson(jsonDecode(response.body)); //as Userdetails)
        //.dynamic((data) => new Userdetails.fromJson(data))
        
        profilename = userdata.profile_name;
        bio = userdata.bio;
        // print(userdata.posts.length);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }

  String profilename;
  String bio;
  int postcount;

  final String profiledefault =
      'https://firebasestorage.googleapis.com/v0/b/instaclone-63929.appspot.com/o/Deafult-Profile-Picture.png?alt=media&token=9a731929-a94c-4ce9-b77c-db317fa6148e';
  MyFeedPage obj = new MyFeedPage();
  @override
  void initState() {
    super.initState();

    fetchPosts();

    setState(() {
      this.profilename = 'Instagrammer';
    });
  }

  int _viewmode = 0;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    SliverGrid condensedview;
    if (userdata != null)
      condensedview = new SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 4),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index > userdata.posts.length) return null;
            // if(list[index].profile_name!=user.displayName) return Container(child: null,);
            return Container(
                child: Image(
              image: NetworkImage(userdata.posts[index].post_pic),
              fit: BoxFit.cover,
            ));
          },
          childCount: userdata.posts.length,
        ),
      );

    SliverList postlistview;
    if (userdata != null)
      postlistview = new SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (index > userdata.posts.length - 1) return null;
          return PrivatePostCard(
            profilename: userdata.profile_name,
            //profileimageurl: userdata.posts[index].post_pic,
            postimageurl: userdata.posts[index].post_pic,
            likes: userdata.posts[index].likes,
            id: userdata.posts[index].id, //passing post id here
            caption: userdata.posts[index].caption,
            user: this.userdata.uid,

            username: userdata.username,
            profileimageurl: userdata.profile_pic,
          );
        }, childCount: userdata.posts.length),
      );
    if (userdata != null) {
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
                  title: Text("@${userdata.username}",
                      //"Profile",
                      style: TextStyle(
                          color: (!isDarkMode) ? Colors.black : Colors.white)),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index > 1) return null;
                    return UserProfilePage(
                        profilename: profilename,
                        postcount: userdata.posts.length,
                        bio: bio,
                        profileimageurl: (userdata.profile_pic == null)
                            ? profiledefault
                            : userdata.profile_pic);
                  }, childCount: 1),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    color: dynamicuicolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.grid_on,
                            color: (_viewmode == 0)
                                ? Colors.red
                                : dynamiciconcolor,
                          ),
                          onPressed: () {
                            setState(() {
                              _viewmode = 0;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.view_list,
                            color: (_viewmode == 1)
                                ? Colors.red
                                : dynamiciconcolor,
                          ),
                          onPressed: () {
                            setState(() {
                              _viewmode = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Divider(
                  height: 0,
                )),
                if (_viewmode == 0)
                  condensedview
                else if (_viewmode == 1)
                  postlistview
              ],
            )),
      );
    } else
      return Scaffold(
        body: Center(
          child:
          CircularProgressIndicator())
      );
  }
}

class UserProfilePage extends StatelessWidget {
  final String profileimageurl;
  final String profilename;
  final String bio;
  final String followers = "169";
  final String following = "269";
  final int postcount;

  UserProfilePage(
      {@required this.profilename,
      this.profileimageurl,
      this.postcount,
      this.bio});
  final String profiledefault =
      'https://firebasestorage.googleapis.com/v0/b/instaclone-63929.appspot.com/o/Deafult-Profile-Picture.png?alt=media&token=9a731929-a94c-4ce9-b77c-db317fa6148e';
  @override
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: dynamicuicolor,
          // child: Align(
          //   alignment:Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                //  alignment:Alignment.topLeft,
                height: 90,
                width: 90,
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: new NetworkImage(profileimageurl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(90.0),
                ),
              ),
              new SizedBox(
                height: MediaQuery.of(context).size.height / 6.5,
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${postcount}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Posts"),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(followers,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Followers"),
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(following,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Following"),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: dynamicuicolor,
          padding: EdgeInsets.only(left: 16.0, bottom: 10),
          child: Text(
            "${profilename}",
            style: TextStyle(
                backgroundColor: dynamicuicolor, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          color: dynamicuicolor,
          padding: EdgeInsets.only(left: 16.0, bottom: 10),
          child: Text(
            "${bio}",
            style: TextStyle(
                fontWeight: FontWeight.w400, backgroundColor: dynamicuicolor),
          ),
        ),
        
      ],
    );
  }
}
