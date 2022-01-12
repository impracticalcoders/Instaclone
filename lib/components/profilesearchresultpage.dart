import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:instaclone/components/constants.dart';
import 'package:instaclone/components/folllowingPage.dart';
import 'package:instaclone/components/privatepostcardwidget.dart';

import 'mainfeed.dart';
import 'privatepostcardwidget.dart';
import 'userdetails.dart';

class ProfileSearchResultPage extends StatefulWidget {
  final String uidretrieve;
  final bool isSelf;
  @override
  ProfileSearchResultPage({
    this.uidretrieve,
    this.isSelf = false,
  });
  @override
  _ProfileSearchResultPageState createState() =>
      _ProfileSearchResultPageState();
}

class _ProfileSearchResultPageState extends State<ProfileSearchResultPage> {
  int _viewmode = 0;
  Userdetails userdata;
  Map<String, dynamic> followData;
  int postcount;
  final String profiledefault =
      'https://firebasestorage.googleapis.com/v0/b/instaclone-63929.appspot.com/o/Deafult-Profile-Picture.png?alt=media&token=9a731929-a94c-4ce9-b77c-db317fa6148e';
  MyFeedPage obj = new MyFeedPage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);
  User getUser() {
    return auth.currentUser;
  }

  bool isFollowing;
  bool isRequestSent = false;
  List<String> mutuals;

  @override
  void initState() {
    super.initState();
    var user = getUser();
    if (user != null) {
      setState(() {
        this.user = user;
        print("State set");
      });
      getFollowersDetails(widget.uidretrieve).then((value) => setState(
            () {
              setState(() => followData = value);
              initializeSelf();
            },
          ));
      fetchPosts();
      // setState(() {});
    }
  }

  Future<Map<String, dynamic>> getFollowersDetails(String _uid) async {
    final response =
        await http.get(Uri.parse(BASE_URL + '/follow/getDetails?uid=${_uid}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));

      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then print error.
      print(response.body);
      throw Exception('Failed to load follow data');
    }
  }

  Future<void> fetchPosts() async {
    String _uid = (widget.isSelf) ? user.uid : widget.uidretrieve;
    final response =
        await http.get(Uri.parse(BASE_URL + '/user_details?uid=${_uid}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        this.userdata =
            Userdetails.fromJson(jsonDecode(response.body)); //as Userdetails)
        //.dynamic((data) => new Userdetails.fromJson(data))

        // print(userdata.posts.length);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }

  onFollowDetailsTap() async {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => FollowingPage(
          users: followData,
          username: userdata.username,
        ),
      ),
    );
  }

  onFollowTap() async {
    final response =
        await http.post(Uri.parse(BASE_URL + '/follow/sendRequest'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'fromUid': user.uid,
              'toUid': widget.uidretrieve,
            }));
    print(response.body);
    if (response.statusCode == 200) {
      print({
        'fromUid': user.uid,
        'toUid': widget.uidretrieve,
      });
    }
  }

  initializeSelf() async {
    var selfFollowDetails = await getFollowersDetails(user.uid);
    List<dynamic> theirFollowers = followData['followers'];
    List<dynamic> theirFollowReqs = followData['follow_reqs'];
    // print(theirFollowReqs);
    List<dynamic> imFollowing = selfFollowDetails['follows'];
    // print(imFollowing);
    if (theirFollowers.any((x) => x['user_uid'] == user.uid)) {
      setState(() {
        isFollowing = true;
      });
    } else {
      setState(() {
        isFollowing = false;
      });
    }

    if (theirFollowReqs.any((x) => x['user_uid'] == user.uid)) {
      setState(() {
        isRequestSent = true;
      });
    } else {
      setState(() {
        isRequestSent = false;
      });
    }

    // print(theirFollowers);
    var _mutuals = imFollowing.toSet().intersection(theirFollowers.toSet());
    print("Mutuals");
    print(_mutuals.toList());
  }

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
            if (index > userdata.posts.length ?? 0) return Container();
            // if(list[index].profile_name!=user.displayName) return Container(child: null,);
            return Container(
                child: Image(
              image: NetworkImage(userdata.posts[index].post_pic),
              fit: BoxFit.cover,
            ));
          },
          childCount: userdata.posts.length ?? 0,
        ),
      );

    SliverList postlistview;
    if (userdata != null)
      postlistview = new SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (index > userdata.posts.length ?? 0 - 1) return Container();
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
        }, childCount: userdata.posts.length ?? 0),
      );
    if (userdata != null) {
      return Scaffold(
        backgroundColor: (!isDarkMode) ? Colors.grey[50] : Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: dynamicuicolor,
              elevation: 3.0,
              title: Text(
                "${userdata.username}",
                //"Profile",
                style: TextStyle(
                    color: (!isDarkMode) ? Colors.black : Colors.white),
              ),
              actions: [
                Icon(
                  Icons.notifications_none_rounded,
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.more_vert,
                ),
                const SizedBox(width: 10),
              ],
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                if (index > 1) return Container();
                return UserProfileHeader(
                  followers: (followData?.isEmpty ?? true)
                      ? null
                      : followData['followers'].length,
                  following: (followData?.isEmpty ?? true)
                      ? null
                      : followData['follows'].length,
                  userdetails: userdata,
                  onFollowingTap: onFollowDetailsTap,
                  onFollowersTap: onFollowDetailsTap,
                  isFollowing: isFollowing,
                  isRequestSent: isRequestSent,
                  onFollowTap: onFollowTap,
                );
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
                        color: (_viewmode == 0) ? Colors.red : dynamiciconcolor,
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
                        color: (_viewmode == 1) ? Colors.red : dynamiciconcolor,
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
                height: 1,
              ),
            ),
            if (_viewmode == 0)
              condensedview
            else if (_viewmode == 1)
              postlistview
          ],
        ),
      );
    } else
      return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class UserProfileHeader extends StatefulWidget {
  final Userdetails userdetails;
  final int followers;
  final int following;
  final Function onFollowingTap;
  final Function onFollowersTap;
  final Function onFollowTap;
  final isFollowing;
  final bool isRequestSent;
  UserProfileHeader({
    this.followers,
    this.following,
    @required this.userdetails,
    this.onFollowingTap,
    this.onFollowersTap,
    @required this.isFollowing,
    @required this.isRequestSent,
    this.onFollowTap,
  });

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  final String profiledefault =
      'https://firebasestorage.googleapis.com/v0/b/instaclone-63929.appspot.com/o/Deafult-Profile-Picture.png?alt=media&token=9a731929-a94c-4ce9-b77c-db317fa6148e';

  @override
  Widget build(BuildContext context) {
    print(widget.isFollowing);
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
                    image: new NetworkImage(widget.userdetails.profile_pic),
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
                  Text("${widget.userdetails.posts.length}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Posts"),
                ],
              ),
              TextButton(
                onPressed: widget.onFollowersTap,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.followers.toString().padLeft(2, '0') ?? "--",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Followers"),
                    ]),
              ),
              TextButton(
                onPressed: widget.onFollowingTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.following.toString().padLeft(2, '0') ?? "--",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Following"),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: dynamicuicolor,
          padding: EdgeInsets.only(left: 16.0, bottom: 10),
          child: Text(
            "${widget.userdetails.bio}",
            style: TextStyle(
                backgroundColor: dynamicuicolor, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          color: dynamicuicolor,
          padding: EdgeInsets.only(left: 16.0, bottom: 10),
          child: Text(
            "${widget.userdetails.bio}",
            style: TextStyle(
                fontWeight: FontWeight.w400, backgroundColor: dynamicuicolor),
          ),
        ),
        Container(
          color: dynamicuicolor,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 16.0, bottom: 10, left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.isFollowing == null
                            ? null
                            : widget.isFollowing || widget.isRequestSent
                                ? null
                                : Colors.lightBlue,
                        border: widget.isFollowing == null
                            ? Border.all(width: 0)
                            : !widget.isFollowing || !widget.isRequestSent
                                ? Border.all(width: 0)
                                : Border.all()),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.isFollowing == null
                          ? "Loading"
                          : widget.isFollowing
                              ? "Following"
                              : (widget.isRequestSent)
                                  ? "Request sent"
                                  : "Follow",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.isFollowing == null
                              ? null
                              : widget.isFollowing || widget.isRequestSent
                                  ? null
                                  : Colors.white),
                    ),
                  ),
                  onTap: widget.isFollowing != null &&
                          widget.isFollowing == false &&
                          widget.isRequestSent == false
                      ? widget.onFollowTap
                      : null,
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: Colors.lightBlue,
                        border: Border.all()),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Send message",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: Colors.lightBlue,
                    border: Border.all()),
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.only(left: 10),
                // width: MediaQuery.of(context).size.width / 3.15,
                child: Icon(Icons.keyboard_arrow_down_sharp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
