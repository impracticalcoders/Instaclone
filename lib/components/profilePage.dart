import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';
import 'Signup.dart';
import 'credits.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future<FirebaseUser> getUser() async {
    return auth.currentUser();
  }

  Future<void> signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  String profilename;

  final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';

  @override
  void initState() {
    super.initState();

    getUser().then((user) {
      if (user != null) {
        setState(() {
          this.user = user;
          profilename = user.displayName;
        });
      } else {
        setState(() {
          this.profilename = 'Instagrammer';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
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
                  title: Text(
                      //"${profilename}",
                      "Profile",
                      style: TextStyle(
                          color: (!isDarkMode) ? Colors.black : Colors.white)),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.info),
                      color: dynamiciconcolor,
                      onPressed: (){
                        Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreditsPage()));
                      },
                    ),
                    
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: dynamiciconcolor,
                      onPressed: signOut,
                    ),
                    
                  ]),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index > 1) return null;
                  return UserProfilePage(
                      profilename: profilename,
                      profileimageurl: (user == null || user.photoUrl == null)
                          ? profiledefault
                          : user.photoUrl);
                }, childCount: 1),
              )

            ],
          )),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final String profileimageurl;
  final String profilename;
  final String bio = "Software developer";
  final String followers = "173";
  final String following = "200";
  final String posts = "11";

  UserProfilePage({
    @required this.profilename,
    this.profileimageurl,
  });
  final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          // child: Align(
          //   alignment:Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                //  alignment:Alignment.topLeft,
                height: 90,
                width: 90,
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: new NetworkImage(profileimageurl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(90.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
              new SizedBox(
                height: MediaQuery.of(context).size.height / 6.5,
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(posts, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Posts"),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(followers,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Followers"),
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(following,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Following"),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 10),
          child: Text(
            "${profilename}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 10),
          child: Text(
            "${bio}",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 16.0, bottom: 10),
          child: RaisedButton(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text(
                "Edit Profile",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));

            },
          ),
        ),
          Container(
           child: CustomScrollView(
            slivers: <Widget>[
               SliverList(
                 delegate:
                 SliverChildBuilderDelegate((BuildContext context,int index){
                   if(index > 8)
                   return null;
                   return Container(color:Colors.white,height:150.0);
                 },
                 )                        
                   ),
            ],
           ),
        )
      
      ],

    );
  }
}

/*

   Widget _buildCoverImage(Size screenSize){
     return Container(

          height: screenSize.height /3,
          decoration:BoxDecoration(
            image:DecorationImage(
              image:AssetImage('assets/Team_IC.jpg'),
                  fit:BoxFit.cover,
            ),
          ),
        );
  
  }

  @override 
  Widget build(Buildcontext Context) {
    size screenSize= MediaQuery.of(context).size.height;
    return Scaffold
  }*/
