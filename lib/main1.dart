import 'package:instaclone/components/createPost.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  List<Widget> pageList = List<Widget>();

  int _cIndex = 0;
  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
    pageList.addAll([
      MyFeedPage(),
      SearchPage(),
      CreatePost(),
      MyActivityPage(),
      ProfilePage(),
    ]);
  }

  _launchURL() async {
    const url = 'https://bit.ly/instaclone1';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
    } else {
      print("not logged in");
    }

    //   _fcm.configure(
    //     FirebaseMessaging.onMessage: (Map<String, dynamic> message) async {
    //       print("onMessage: $message ");

    //       showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(18.0)),
    //           title: Text(message['notification']['title']),
    //           content: Text(message['notification']['body']),
    //           actions: <Widget>[
    //             FlatButton(
    //               child: Text('OK'),
    //               onPressed: () {
    //                 if (message['notification']['title']
    //                         .toString()
    //                         .contains("Update") ||
    //                     message['notification']['body']
    //                         .toString()
    //                         .contains("Update") ||
    //                     message['notification']['body']
    //                         .toString()
    //                         .contains("update")) {
    //                   _launchURL;
    //                   print("URL launch attempted");
    //                 }
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //     onLaunch: (Map<String, dynamic> message) async {
    //       print("onLaunch: $message");
    //       // TODO optional
    //       if (message['notification']['title'].toString().contains("Update") ||
    //           message['notification']['body'].toString().contains("Update") ||
    //           message['notification']['body'].toString().contains("update")) {
    //         _launchURL;
    //         print("URL launch attempted");
    //       }
    //     },
    //     onResume: (Map<String, dynamic> message) async {
    //       print("onResume: $message");
    //       // TODO optional
    //       if (message['notification']['title'].toString().contains("Update") ||
    //           message['notification']['body'].toString().contains("Update") ||
    //           message['notification']['body'].toString().contains("update")) {
    //         _launchURL;
    //         print("URL launch attempted");
    //       }
    //     },
    //   );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  User getUser() {
    return auth.currentUser;
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
          body: IndexedStack(
            index: _cIndex,
            children: _pageOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: dynamicuicolor,
            // notchMargin: 8.0,
            type: BottomNavigationBarType.fixed,

            currentIndex: _cIndex,
            onTap: _incrementTab,
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            items: [
              BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.home, color: dynamiciconcolor, size: 30),
                activeIcon: Icon(Icons.home, color: Colors.redAccent, size: 30),
              ),
              BottomNavigationBarItem(
                label: "",

                icon: Icon(FontAwesomeIcons.search, color: dynamiciconcolor),
                activeIcon:
                    Icon(FontAwesomeIcons.search, color: Colors.redAccent),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.add_box, color: dynamiciconcolor, size: 30),
                activeIcon:
                    Icon(Icons.add_box, color: Colors.redAccent, size: 30),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.favorite_border,
                    color: dynamiciconcolor, size: 30),
                activeIcon:
                    Icon(Icons.favorite, color: Colors.redAccent, size: 30),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Icon(FontAwesomeIcons.user, color: dynamiciconcolor),
                activeIcon:
                    Icon(FontAwesomeIcons.userAlt, color: Colors.redAccent),
              )
            ],
          ),
        ),
        //drawer: Drawer(),
        // ),
        ChatsPage(user),
      ],
    );
  }
}
