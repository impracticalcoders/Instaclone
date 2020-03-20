import 'package:Instaclone/components/mainfeed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Instaclone/main.dart';
import 'dart:async';
import 'dart:math';
import 'package:Instaclone/main1.dart';
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
    getUser().then((user) {
      if (user != null) {
        print('Already logged in as ' + user.displayName);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } else {
        print("Not logged in");
      }
    });

    super.initState();
  }

  Future<void> signIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      print('signed in as ' + user.displayName);

//https://insta-clone-backend.now.sh/ DON'T REMOVE

      final response = await http.post(
          "https://insta-clone-backend.now.sh/auth",
          headers: {"Content-type": "application/json"},
          body: '{"uid":"${user.uid}"}');

      int status = response.statusCode;
      print(status);
      //207 if the user login's for the first time
      //208 if its an existing user
      if(response.statusCode==207)
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      else if(response.statusCode==208)
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupPage()));

      //400 if the uid is empty

    } catch (err) {
      print(err);
    }
  }

  Future<FirebaseUser> getUser() async {
    return auth.currentUser();
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
    String logourl=(isDarkMode)?'assets/TeamIC1.png':'assets/TeamIC2.png';
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    Color dynamicbgcolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Colors.black;
    

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
                    child: Image(image: AssetImage('assets/signin.png'),height: 50,),
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
