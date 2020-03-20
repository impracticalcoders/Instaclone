import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'likes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ffi';

class MyActivityPage extends StatefulWidget {
  @override
  _MyActivityPageState createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
    var _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Like> list = List();
  FirebaseUser user;
  @override
  void initState ()  {
    super.initState();
    
   initialize();
 
  }
  void initialize() async{
  var user = await getUser();
  
    if (user != null) {
      setState(() {
        this.user = user;
      });
      print('Accessing activity page as ' + user.displayName);

      fetchActivities();

      print(list.length);
    } else {
      print("not logged in");
    }
  }

  
  Future<FirebaseUser> getUser() async {
    return auth.currentUser();
  }

  Future<Void> fetchActivities() async {
    final response = await http
        .get('https://insta-clone-backend.now.sh/activity?uid=${user.uid}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      
      setState(() {
        this.list = (json.decode(response.body) as List)
            .map((data) => new Like.fromJson(data))
            .toList();
      });
      print("${list.length}");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //this.list=[{'activity_text':'Error loading activity','post_pic':'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png'}]
      throw Exception('Failed to load likes');
    }
  }
  

  /// the url should be https://insta-clone-backend.now.sh/activity?uid=${user.uid}
  /// user.uid to be got from firebaseUser
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    Color dynamictextcolor =
        (!isDarkMode) ? Color.fromRGBO(35, 35, 35, 1.0) : new Color(0xfff8faf8);
    final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';
    return Scaffold(
      key:_scaffoldKey,
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
              title: Text("Activity",
                  style: TextStyle(
                      color: (!isDarkMode) ? Colors.black : Colors.white)),
            ),
            SliverList(
             
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                // if (index > this.list.length) return null;
                if(this.list[index].uid==this.user.uid) return Container();
                if(index==0) return Container();
                return customcontainer(
                  activity_text: this.list[index].activity_text,
                  profileimageurl:user.photoUrl,
                  postimageurl: this.list[index].post_pic,
                );
              }, childCount: this.list.length),
            )
          ],
        ),
      ),
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
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
        child:ListTile(
          leading:Container(
            height: 40.0,
            width: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: new NetworkImage(
                  profileimageurl != null ? profiledefault : profiledefault,
                ),
              ),
            ),
          ),
          //contentPadding: EdgeInsets.all(16.0),
          
          trailing:  Container(
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
        )
        );
  }
}
