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
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? Colors.white : Color.fromRGBO(35, 35, 35, 1.0);

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
              centerTitle: true,
              title: Text("InstaClone",
                  style: TextStyle(
                      color: (!isDarkMode) ? Colors.black : Colors.white)),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(
                    Icons.camera_alt,
                    color: dynamiciconcolor,
                  ),
                  //onPressed: () => Scaffold.of(context).openDrawer(),
                  onPressed: () {},
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.send),
                  color: dynamiciconcolor,
                  onPressed: () {},
                )
              ],
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
      bottomNavigationBar: BottomAppBar(
        color: dynamicuicolor,
        notchMargin: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box),
              onPressed: () {},
            )
          ],
        ),
      ),
      //drawer: Drawer(),
    );
  }
}
