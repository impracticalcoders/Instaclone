import 'package:Instaclone/components/createPost.dart';
import 'package:flutter/material.dart';
import 'components/activitypage.dart';
import 'components/mainfeed.dart';
import 'components/loginpage.dart';
import 'components/searchpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaClone',
      theme: ThemeData(
        primarySwatch: Colors.grey,
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
  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override

  final _pageOptions = [
      MyFeedPage(),
      SearchPage(),
      CreatePost(),
      MyActivityPage(),
      LoginPage(),
    ];



  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);

    return Scaffold(
      body:_pageOptions[_cIndex] ,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _cIndex,
        
        
        
          items:[
            BottomNavigationBarItem(
            
              icon: Icon(Icons.home,color:dynamiciconcolor),
              title: Text("Home"),
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,color:dynamiciconcolor),
              title: Text("Search"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              title:Text("Add post")  
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite,color:dynamiciconcolor ,),
             
              title: Text("Activity"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box,color:dynamiciconcolor),
              title: Text("Login"),
            )
          ],
        onTap: (index){
            _incrementTab(index);}
      ),
      //drawer: Drawer(),
    );
  }
}
