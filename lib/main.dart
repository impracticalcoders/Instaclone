import 'package:Instaclone/components/createPost.dart';
import 'package:flutter/material.dart';

import 'main1.dart';
import 'components/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';


// AuthService appAuth = new AuthService();

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();

  // WidgetsFlutterBinding.ensureInitialized();
  // Set default home.
  Widget _defaultHome;

  if(user==null){
    _defaultHome =  new LoginPage();
  }
  else {
    _defaultHome = new MyHomePage();
  }
 
// Run app!
  runApp(new MaterialApp(
    title: 'App',
    debugShowCheckedModeBanner: false,
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new MyHomePage(),
      '/login': (BuildContext context) => new LoginPage()
    },
  ));
}
/*class MyApp extends StatelessWidget {
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
}*/
