import 'package:Instaclone/components/createPost.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'main1.dart';
import 'components/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// AuthService appAuth = new AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user = auth.currentUser;
  print(user);

  // Set default home.
  Widget _defaultHome;

// Run app!
  runApp(new MaterialApp(
    title: 'Instaclone',
    debugShowCheckedModeBanner: false,
    home: user == null ? LoginPage() : MyHomePage(),
    theme: ThemeData(primarySwatch: Colors.grey),
    darkTheme: ThemeData(
        brightness: Brightness.dark, primarySwatch: Colors.deepOrange),
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
