import 'package:flutter/material.dart';

class MyActivityPage extends StatefulWidget {
  @override
  _MyActivityPageState createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    Color dynamictextcolor =
        (!isDarkMode) ? Color.fromRGBO(35, 35, 35, 1.0) : new Color(0xfff8faf8);
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
              title: Text("Activity",
                  style: TextStyle(
                      color: (!isDarkMode) ? Colors.black : Colors.white)),
            ),
            
            SliverGrid.count(
              crossAxisCount: 1,
              children: <Widget>[
                customcontainer(profilename: "Zelda",)
              ],
            )    
              
            
          ],
        ),
      ),);
  }
}





class customcontainer extends StatelessWidget {
  final String postimageurl;
  final String profileimageurl;
  final String profilename;

  customcontainer({
    @required this.profilename,
    this.profileimageurl,
    this.postimageurl,
  });

  final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
          new Container(
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
          Text(profilename + "has liked your post"),
          new Container(
            height: 40.0,
            width: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: new NetworkImage(
                  postimageurl != null ? postimageurl : profiledefault,
                ),
              ),
            ),
          ),
        ]));
  }
}
