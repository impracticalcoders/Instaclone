import 'package:Instaclone/components/createPost.dart';
import 'package:flutter/material.dart';
import 'components/activitypage.dart';
import 'components/mainfeed.dart';
import 'components/profilePage.dart';
import 'components/searchpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'components/profilePage.dart';
import 'main1.dart';
import 'components/loginpage.dart';


AuthService appAuth = new AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set default home.
  Widget _defaultHome = new LoginPage();

  // Get result of the login function.
  bool _result;// doesn't work at the moment
  if(await appAuth.loginstat()!=null)
  _result = await appAuth.loginstat();
  else
  _result = false;
  if (_result) {
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
