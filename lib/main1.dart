import 'package:Instaclone/components/createPost.dart';
import 'package:flutter/material.dart';
import 'components/activitypage.dart';
import 'components/mainfeed.dart';
import 'components/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/searchpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'components/profilePage.dart';


class MyHomePage extends StatefulWidget {
 // MyHomePage({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _cIndex = 0;
  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }
  @override
  void initState() { 
    super.initState();
    
  }


  final _pageOptions = [
      MyFeedPage(),
      SearchPage(),
      CreatePost(),
      MyActivityPage(),
      ProfilePage(),
    ];

  

  @override

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);

    return Scaffold(
      body:_pageOptions[_cIndex] ,
      bottomNavigationBar:BottomAppBar(
        color: dynamicuicolor,
        
        notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            IconButton(
            
              icon: Icon(Icons.home,color:dynamiciconcolor,size: 30),
              onPressed:(){ 
                _incrementTab(0);
               }
              
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.search,color:dynamiciconcolor),
              onPressed:(){ 
                _incrementTab(1);
               }
            ),
            IconButton(
              icon: Icon(Icons.add_box,color:dynamiciconcolor ,size: 30),
              onPressed:(){ 
                _incrementTab(2);
               }
            ),
            IconButton(
              icon: Icon(Icons.favorite_border,color:dynamiciconcolor ,size: 30),
             
              onPressed:(){ 
                _incrementTab(3);
               }
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.user,color:dynamiciconcolor),
              onPressed:(){
            _incrementTab(4);
            }
                
            )
          ],
       
      ),),
      //drawer: Drawer(),
    );
  }
}