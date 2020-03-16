

import 'package:flutter/material.dart';
import 'components/postcardwidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaClone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'InstaClone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: new Color(0xfff8faf8),
              elevation: 3.0,
              centerTitle: true,
              title: Text("InstaClone",style:TextStyle(color: Colors.black)),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 1,
              children: <Widget>[
                PostCard(
                  profilename: "MKBHD",
                  postimageurl:
                      'https://magic-mark.com/wp-content/uploads/2019/10/mkbhd-intro2019-thumbnail3.jpg',
                  profileimageurl:
                      'https://pbs.twimg.com/profile_images/1212149592403382281/cI0-xyss_400x400.jpg',
                ),
                PostCard(
                  profilename: "Verge",
                ),
                PostCard(
                  profilename: "MKBHD",
                  postimageurl:
                      'https://magic-mark.com/wp-content/uploads/2019/10/mkbhd-intro2019-thumbnail3.jpg',
                  profileimageurl:
                      'https://pbs.twimg.com/profile_images/1212149592403382281/cI0-xyss_400x400.jpg',
                ),
                PostCard(
                  profilename: "Verge",
                ),
              ],
            )
          ],
        ),
      ),
      drawer: Drawer(),
    );
  }
}
