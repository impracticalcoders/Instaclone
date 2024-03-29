import 'dart:convert';

import 'package:instaclone/components/mainfeed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instaclone/main.dart';
import 'dart:async';
import 'dart:math';
import 'package:instaclone/main1.dart';
import 'package:instaclone/services/api.dart';
import 'Signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    var user = getUser();
    if (user != null) {
      print('Already logged in as ' + user.displayName);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      print("Not logged in");
    }

    super.initState();
  }

  Future<void> signIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User user = authResult.user;

      print('signed in as ' + user.displayName);

      final response = await http.post(Uri.parse("${api_url}/auth"),
          headers: {"Content-type": "application/json"},
          body: jsonEncode({
            'uid': user.uid,
            'profile_name': user.displayName,
            'profile_pic': user.photoURL,
          }));

      int status = response.statusCode;
      print(status);
      //207 if the user login's for the first time
      //208 if its an existing user
      if (response.statusCode == 208)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      else if (response.statusCode == 207)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignupPage()));

      //400 if the uid is empty

    } catch (err) {
      print(err);
    }
  }

  User getUser() {
    return auth.currentUser;
  }

  void showSnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String logourl = (isDarkMode) ? 'assets/TeamIC1.png' : 'assets/TeamIC2.png';
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    Color dynamicbgcolor = (!isDarkMode) ? new Color(0xfff8faf8) : Colors.black;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: dynamicbgcolor,
      //no need of appbar for this page
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Instaclone',
                  style: TextStyle(
                    fontFamily: 'Billabong',

                    fontSize: 50,
                    //color: dynamiciconcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 35,
                  color: Colors.red[600],
                ),
                Text(
                  'Hey there, welcome to Instaclone , a limited feature and working remake of Instagram .',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '\nTo continue,\nPlease login with ur Google Account',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                    child: Image(
                      image: AssetImage('assets/signin.png'),
                      height: 50,
                    ),
                    onPressed: signIn
                    //HI AAKASH, WASH  UR  HANDS : SURE CAP! lol

                    ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  'Brought to you by',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Image(
                  image: AssetImage(logourl),
                  height: 150,
                  width: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
