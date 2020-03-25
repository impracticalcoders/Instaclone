import 'dart:ffi'; //for future<void>
import 'package:flutter/cupertino.dart';
import 'package:Instaclone/components/privatepostcardwidget.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';
import 'Signup.dart';
import 'credits.dart';
import 'mainfeed.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'userdetails.dart';
import 'privatepostcardwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
    @override
  bool get wantKeepAlive => true;
  
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  int newlength;
  Userdetails userdata;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);

  Future<FirebaseUser> getUser() async {
    return auth.currentUser();
  }

  Future<Void> fetchPosts() async {
    print("function called");
    final response = await http
        .get('https://instacloneproduction.glitch.me/user_details?uid=${user.uid}');
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        this.userdata =
            Userdetails.fromJson(jsonDecode(response.body)); //as Userdetails)
        //.dynamic((data) => new Userdetails.fromJson(data))
        
        profilename = userdata.profile_name??"";
        bio = userdata.bio??"";
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
    getUser().then((user) {
      if (user != null) {
        setState(() {
          this.user = user;
          print("State set");
          profilename ="";
          userdata = new Userdetails(
              'Loading...',
              'Instagrammer',
              'username',
              "",
              'uid',
              [Post(post_pic: profiledefault, likes: 0, caption: "loading")]);
        });
        fetchPosts();
      } else {
        setState(() {
          this.profilename = 'Instagrammer';
        });
      }
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
            int cindex = userdata.posts.length-1-index;
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
          int cindex = userdata.posts.length-1-index;
           return PrivatePostCard(
            profilename: userdata.profile_name,
            //profileimageurl: userdata.posts[index].post_pic,
            postimageurl: userdata.posts[cindex].post_pic,
            likes: userdata.posts[cindex].likes,
            id: userdata.posts[cindex].id,//passing post id here
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
                                    builder: (context) =>
                                        CreditsPage()));
                         
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        color: dynamiciconcolor,
                        onPressed: (){
                         showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoActionSheet(
                                    title: Text("Logout"),
                                    message:
                                        const Text('Do you want to proceed?'),
                                    actions: <Widget>[
                                      CupertinoActionSheetAction(
                                        isDestructiveAction: true,
                                        child: const Text('Yes'),
                                        onPressed: () {
                                         signOut();
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
                        }
                       ,
                      ),
                    ]),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index > 1) return null;
                    return UserProfilePage(
                        profilename: profilename,
                        postcount: userdata.posts.length,
                        bio: bio??"",

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
                          icon: Icon(Icons.grid_on,color: (_viewmode==0)?Colors.red :dynamiciconcolor ,),
                          onPressed: () {
                            setState(() {
                              _viewmode = 0;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.view_list,color: (_viewmode==1)?Colors.red :dynamiciconcolor ,),
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
