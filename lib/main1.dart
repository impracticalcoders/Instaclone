import 'package:Instaclone/components/createPost.dart';
import 'package:flutter/material.dart';
import 'components/activitypage.dart';
import 'components/mainfeed.dart';
import 'components/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/searchpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'components/profilePage.dart';
import 'components/Chat/chatsPage.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';


class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  int _cIndex = 0;
  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        setState(() {
          this.user = user;
        });
        

        

      
      } else {
        print("not logged in");
      }
    });

    _fcm.configure(
      
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message ");
          
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );
        },
        onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
            // TODO optional
        },
      );
    }

  

   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future<FirebaseUser> getUser() async {
    return auth.currentUser();
  }

  final _pageOptions = [
    MyFeedPage(),
    SearchPage(),
    CreatePost(),
    MyActivityPage(),
    ProfilePage(),
  ];

  PageController _controller = PageController(
    initialPage: 0,
    keepPage: true,
    viewportFraction: 0.999,
  );

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);

    return PageView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _controller,
      
      
      children: [
        Scaffold(
          backgroundColor: (!isDarkMode) ? Colors.white : Colors.black,
          body: _pageOptions[_cIndex],
          bottomNavigationBar: BottomAppBar(
            color: dynamicuicolor,
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.home, color: dynamiciconcolor, size: 30),
                    onPressed: () {
                      _incrementTab(0);
                    }),
                IconButton(
                    icon:
                        Icon(FontAwesomeIcons.search, color: dynamiciconcolor),
                    onPressed: () {
                      _incrementTab(1);
                    }),
                IconButton(
                    icon:
                        Icon(Icons.add_box, color: dynamiciconcolor, size: 30),
                    onPressed: () {
                      _incrementTab(2);
                    }),
                IconButton(
                    icon: Icon(Icons.favorite_border,
                        color: dynamiciconcolor, size: 30),
                    onPressed: () {
                      _incrementTab(3);
                    }),
                IconButton(
                    icon: Icon(FontAwesomeIcons.user, color: dynamiciconcolor),
                    onPressed: () {
                      _incrementTab(4);
                    })
              ],
            ),
          ),
          //drawer: Drawer(),
        ),
        ChatsPage(user),
      ],
    );
  }
}
