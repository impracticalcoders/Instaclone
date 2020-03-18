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
      if(response.statusCode==207||response.statusCode==208)
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));

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
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);

    return Scaffold(
      key: _scaffoldKey,
      //no need of appbar for this page
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 120, 30, 0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Instaclone',
                  style: TextStyle(
                    fontFamily: 'Billabong',

                    fontSize: 50,
                    //color: dynamiciconcolor,
                  ),
                ),
                Divider(
                  height: 35,
                  color: Colors.red[600],
                ),
                SizedBox(
                  height: 60,
                ),
                FlatButton(
                    child: Image(image: AssetImage('assets/signin.png')),
                    onPressed: signIn
                    //HI AAKASH, WASH  UR  HANDS : SURE CAP! lol

                    ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  'Brought to you by',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                  ),
                ),
                Image(
                  image: AssetImage('assets/Team_IC.jpg'),
                  height: 150,
                  width: 150,
                ),
                RaisedButton(
                  child: Text("Signup page - soundarya"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function logout(){
//   final FirebaseAuth auth = FirebaseAuth.instance;
//    auth.signOut();
   
//    print("Logged out");
    
    
//   }

// class AuthService{
// final FirebaseAuth auth = FirebaseAuth.instance;
  
//  Future<bool> loginstat() async {
    
//       if(auth.currentUser()==null)
//       return false;
//       else 
//       return true;
//     }
    
//   }

  





// /* 
// class AuthService {
//   // Login
//   Future<bool> login() async {
//     // Simulate a future for response after 2 second.
//     return await new Future<bool>.delayed(
//       new Duration(
//         seconds: 2
//       ), () => new Random().nextBool()
//     );
//   }

//   // Logout
//   Future<void> logout() async {
//     // Simulate a future for response after 1 second.
//     return await new Future<void>.delayed(
//       new Duration(
//         seconds: 1
//       )
//     );
//   }
// } */