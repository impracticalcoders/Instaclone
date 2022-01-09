import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:instaclone/components/privatepostcardwidget.dart';

import 'Signup.dart';
import 'constants.dart';
import 'credits.dart';
import 'loginpage.dart';
import 'mainfeed.dart';
import 'privatepostcardwidget.dart';
import 'userdetails.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  int newlength;
  Userdetails userdata;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);

  User getUser() {
    return auth.currentUser;
  }

  Map<String, dynamic> followData;
  Future<void> getFollowersDetails() async {
    final response = await http
        .get(Uri.parse(BASE_URL + '/follow/getDetails?uid=${user.uid}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      setState(() {
        followData = jsonDecode(response.body);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then print error.
      throw Exception('Failed to load follow data');
    }
  }

  Future<void> fetchPosts() async {
    print("function called");
    final response = await http.get(Uri.parse(
        'https://instaclonebackendrit.herokuapp.com/user_details?uid=${user.uid}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        this.userdata =
            Userdetails.fromJson(jsonDecode(response.body)); //as Userdetails)
        //.dynamic((data) => new Userdetails.fromJson(data))

        profilename = userdata.profile_name ?? "";
        bio = userdata.bio ?? "";
        // print(userdata.posts.length);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
    var user = getUser();
    if (user != null) {
      setState(() {
        this.user = user;
        print("State set");
        profilename = "";
        userdata = new Userdetails(
            'Loading...',
            'Instagrammer',
            'username',
            "",
            'uid',
            [Post(post_pic: profiledefault, likes: 0, caption: "loading")]);
      });
      fetchPosts();
      getFollowersDetails();
    } else {
      setState(() {
        this.profilename = 'Instagrammer';
      });
    }
  }

  _deletepostreq() async {
    //https://insta-clone-backend.now.sh

    // set up POST request arguments
    String url = 'https://instaclonebackendrit.herokuapp.com/delete_post';

    Map<String, String> headers = {"Content-type": "application/json"};
    int i;
    int intialpostcount = userdata.posts.length;
    for (i = 0; i < userdata.posts.length; i++) {
      print(
          "Delete requested for post_id${userdata.posts[i].id} by Uid: ${user.uid}");
      String json =
          '{"post_id": "${userdata.posts[i].id}","uid" : "${user.uid}"}';
      // make POST request
      final response =
          await http.post(Uri.parse(url), headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      print("POST delete req response ${statusCode}");
      if (response.statusCode == 200) {
        print("Post deleted");
      } else {
        print("Post not deleted");
        var snackbar = new SnackBar(
            content: new Text("There was a problem deleting your posts"));
        Scaffold.of(context).showSnackBar(snackbar);

        break;
      }
    }
    if (i == intialpostcount) {
      await _deleteuserdata();
      await deleteacc();
    }
  }

  _deleteuserdata() async {
    //https://insta-clone-backend.now.sh

    // set up POST request arguments
    String url = 'https://instaclonebackendrit.herokuapp.com/delete_user';

    Map<String, String> headers = {"Content-type": "application/json"};

    print("Delete requested for Uid: ${user.uid}");
    String json = '{"uid" : "${user.uid}"}';
    // make POST request
    final response =
        await http.post(Uri.parse(url), headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    print("Userdata delete req response ${statusCode}");
    if (response.statusCode == 200) {
      print("Userdata deleted");
    } else {
      print("Userdata not deleted");
      var snackbar = new SnackBar(
          content: new Text("There was a problem deleting your profile data"));
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Future<void> deleteacc() async {
    User current = auth.currentUser;

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await current.reauthenticateWithCredential(credential);
    await current.delete();
    await auth.signOut();
    await googleSignIn.signOut();

    print("User account deleted");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
            int cindex = userdata.posts.length - 1 - index;
            // if(list[index].profile_name!=user.displayName) return Container(child: null,);
            return Container(
                child: Image(
              image: NetworkImage(userdata.posts[cindex].post_pic),
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
          int cindex = userdata.posts.length - 1 - index;
          return PrivatePostCard(
            profilename: userdata.profile_name,
            postimageurl: userdata.posts[cindex].post_pic,
            likes: userdata.posts[cindex].likes,
            id: userdata.posts[cindex].id, //passing post id here
            caption: userdata.posts[cindex].caption,
            user: this.user,

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
                            color:
                                (!isDarkMode) ? Colors.black : Colors.white)),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.info),
                        color: dynamiciconcolor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreditsPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        color: dynamiciconcolor,
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoActionSheet(
                                    title: Text("Logout or Delete"),
                                    message: const Text(
                                        'Please tap on the desired action'),
                                    actions: <Widget>[
                                      CupertinoActionSheetAction(
                                        isDestructiveAction: false,
                                        child: const Text('Logout'),
                                        onPressed: () {
                                          signOut();
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        isDestructiveAction: true,
                                        child: const Text('Delete account'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CupertinoActionSheet(
                                                    title: Text(
                                                        "Instaclone Account Deletion"),
                                                    message: const Text(
                                                        'This is a destructive action and cannot be reverted.\nAll your posts will be deleted.\nYou will be required to re-authenticate with your Google Account before deleting.\n'),
                                                    actions: <Widget>[
                                                      CupertinoActionSheetAction(
                                                        isDestructiveAction:
                                                            true,
                                                        child: const Text(
                                                            'Understood, proceed to delete'),
                                                        onPressed: () {
                                                          _deletepostreq();
                                                        },
                                                      ),
                                                    ],
                                                    cancelButton:
                                                        CupertinoActionSheetAction(
                                                      child:
                                                          const Text('Cancel'),
                                                      isDefaultAction: true,
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                    ),
                                                  ));
                                        },
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      child: const Text('Cancel'),
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context, 'Cancel');
                                      },
                                    ),
                                  ));
                        },
                      ),
                    ]),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index > 1) return null;
                    return UserProfilePage(
                        profilename: profilename,
                        postcount: userdata.posts.length,
                        bio: bio ?? "",
                        followers: (followData?.isEmpty ?? true)
                            ? null
                            : followData['followers'].length,
                        following: (followData?.isEmpty ?? true)
                            ? null
                            : followData['follows'].length,
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
      return Center(
        child: Text("Loading"),
      );
  }
}

class UserProfilePage extends StatelessWidget {
  final String profileimageurl;
  final String profilename;
  final String bio;
  final int followers;
  final int following;
  final int postcount;

  UserProfilePage(
      {@required this.profilename,
      this.profileimageurl,
      this.postcount,
      this.bio,
      this.followers,
      this.following});
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
                    Text(followers.toString().padLeft(2, "0") ?? "--",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Followers"),
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(following.toString().padLeft(2, "0") ?? "--",
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
        Container(
          color: dynamicuicolor,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 16.0, bottom: 10),
          child: RaisedButton(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.15,
              child: Text(
                "Edit Profile",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupPage()));
            },
          ),
        ),
      ],
    );
  }
}
