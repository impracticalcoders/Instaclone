import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/components/constants.dart';
import 'package:instaclone/components/profilesearchresultpage.dart';
import 'likes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyActivityPage extends StatefulWidget {
  @override
  _MyActivityPageState createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Like> list = [];
  User user;

  Map<String, dynamic> followData;
  @override
  void initState() {
    super.initState();

    initialize();
  }

  void initialize() async {
    var user = getUser();
    print(user.uid);
    if (user != null) {
      setState(() {
        this.user = user;
      });
      print('Accessing activity page as ' + user.displayName);

      fetchActivities();
      getFollowersDetails();
      print(list.length);
    } else {
      print("not logged in");
    }
  }

  User getUser() {
    return auth.currentUser;
  }

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

  Future<void> fetchActivities() async {
    final response = await http.get(Uri.parse(
        'https://instaclonebackendrit.herokuapp.com/activity?uid=${user.uid}'));
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      setState(() {
        this.list = (json.decode(response.body) as List).map((data) {
          print(data);
          return new Like.fromJson(data);
        }).toList();
      });
      print("activity list length ${list.length}");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //this.list=[{'activity_text':'Error loading activity','post_pic':'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png'}]
      throw Exception('Failed to load likes');
    }
  }

  onAcceptTap(String requestId) async {
    setState(() {
      followData = null;
    });
    final response = await http.post(
      Uri.parse(BASE_URL + '/follow/acceptRequest'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'followId': requestId,
        },
      ),
    );
    print(response.body);
    if (response.statusCode == 200) {
      getFollowersDetails();
    }
  }

  /// the url should be https://insta-clone-backend.now.sh/activity?uid=${user.uid}
  /// user.uid to be got from User
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    Color dynamictextcolor =
        (!isDarkMode) ? Color.fromRGBO(35, 35, 35, 1.0) : new Color(0xfff8faf8);
    final String profiledefault =
        'http://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png';
    var titleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    if (user != null) {
      return Scaffold(
          key: _scaffoldKey,
          backgroundColor: (!isDarkMode) ? Colors.white : Colors.black,
          appBar: AppBar(
            backgroundColor: dynamicuicolor,
            title: Text(
              "Activity",
              style: appBarTitleTextStyle,
            ),
            elevation: 0,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Follow Requests (${followData != null ? followData['follow_reqs'].length : "--"})",
                  style: titleTextStyle,
                ),
                const SizedBox(height: 10),
                followData == null
                    ? Text("Loading..")
                    : Expanded(
                        child: ListView.builder(
                            itemCount: followData['follow_reqs'].length,
                            itemBuilder: (context, index) {
                              var item = followData['follow_reqs'][index];
                              return ListTile(
                                title: Text(item['username']),
                                subtitle: Text(
                                  item['profile_name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.2),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: CircleAvatar(
                                    radius: 22,
                                    child: CachedNetworkImage(
                                      imageUrl: item['profile_pic'],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    onAcceptTap(item['requestId']);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.lightBlue,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 18.0),
                                    child: Text(
                                      "Accept",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileSearchResultPage(
                                                uidretrieve: item['user_uid'],
                                              )));
                                },
                              );
                            }),
                      ),
                const SizedBox(height: 10),
                Text(
                  "Likes",
                  style: titleTextStyle,
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      // if (index > this.list.length) return null;
                      if (this.list[index].uid == this.user.uid)
                        return Container();
                      return customcontainer(
                        activity_text: this.list[index].activity_text,
                        profileimageurl: this.list[index].profile_pic,
                        postimageurl: this.list[index].post_pic,
                      );
                    },
                    itemCount: this.list.length,
                    physics: BouncingScrollPhysics(),
                  ),
                ),
              ],
            ),
          ));
    } else
      return Scaffold(
        body: CircularProgressIndicator(),
      );
  }
}

class customcontainer extends StatelessWidget {
  final String postimageurl;
  final String profileimageurl;
  final String activity_text;

  customcontainer({
    @required this.activity_text,
    this.profileimageurl,
    this.postimageurl,
  });

  final String profiledefault =
      'http://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png';
  @override
  Widget build(BuildContext context) {
    print("activity text is $activity_text");
    return Container(
        height: 60,
        child: ListTile(
          leading: Container(
            height: 40.0,
            width: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: new NetworkImage(
                  profileimageurl != null ? profileimageurl : profiledefault,
                ),
              ),
            ),
          ),
          //contentPadding: EdgeInsets.all(16.0),

          trailing: Container(
            height: 40.0,
            width: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: new NetworkImage(
                  postimageurl != null ? postimageurl : profiledefault,
                ),
              ),
            ),
          ),
          title: Text(activity_text),
        ));
  }
}
