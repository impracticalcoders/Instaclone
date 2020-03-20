import 'package:Instaclone/main1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
    FirebaseUser user;
    String profileimageurl;

  Widget appBarTitle = new Text("Edit Profile");
  Icon actionIcon = new Icon(Icons.search);
  TextEditingController profileNameController = new TextEditingController(); 
  TextEditingController usernameController = new TextEditingController(); 
  TextEditingController bioController = new TextEditingController(); 

@override
void initState() { 
  super.initState();
  getUser().then((user) =>setState((){this.user =user;
  this.profileimageurl=user.photoUrl;}) );

}
 Future<FirebaseUser> getUser() async {
    return FirebaseAuth.instance.currentUser();
  }

  _updateProfileRequest() async{

     // set up POST request arguments
    String url = 'https://insta-clone-backend.now.sh/profile_update';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"uid": "${this.user.uid}","profile_name":"${this.profileNameController.text}","username":"${this.usernameController.text}","bio":"${this.bioController.text}","profile_pic":"${this.user.photoUrl}"}';
    // make POST request
    final response = await http.post(url, headers: headers, body: json);
  
  if(response.statusCode==400){
    print("fill in all the fields");
  }
  else if(response.statusCode==200){
    print("success");
    
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  }
  }
  

  @override
  Widget build(BuildContext context) {
    final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: appBarTitle,
      ),
      body:SingleChildScrollView(child: Padding(
        padding: EdgeInsets.fromLTRB(30, 80, 30, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                //  alignment:Alignment.topLeft,
                height: 90,
                width: 90,
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: new NetworkImage(profileimageurl != null ? profileimageurl : profiledefault),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(90.0),
                  
                ),
              ),
              Divider(
                height: 35,
                color: Colors.red[600],
              ),
              Text(
                'Please add your new details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name",style: TextStyle(fontWeight: FontWeight.w300),),
                      TextField(
                        
                        controller: profileNameController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Username",style: TextStyle(fontWeight: FontWeight.w300),),
                      TextField(
                        /*decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),*/
                        controller: usernameController,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Bio",style: TextStyle(fontWeight: FontWeight.w300),),
                      TextField(
                        /*decoration: InputDecoration(
                          hintText: 'Bio',
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),*/
                        
                        controller: bioController,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.red[500],
                              child: FlatButton(
                                onPressed: _updateProfileRequest,
                                child: Text(
                                  'Save Changes',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
