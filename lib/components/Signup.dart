import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
    FirebaseUser user;

  Widget appBarTitle = new Text("AppBar Title");
  Icon actionIcon = new Icon(Icons.search);
  TextEditingController profileNameController = new TextEditingController(); 
  TextEditingController usernameController = new TextEditingController(); 
  TextEditingController bioController = new TextEditingController(); 

@override
void initState() { 
  super.initState();
  getUser().then((user) =>setState((){this.user =user;}) );

}
 Future<FirebaseUser> getUser() async {
    return FirebaseAuth.instance.currentUser();
  }

  _updateProfileRequest() async{

     // set up POST request arguments
    String url = 'https://insta-clone-backend.now.sh/likes';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"uid": "${this.user.uid}","profile_name":"${this.profileNameController.text}","username":"${this.usernameController.text}","bio":"${this.bioController.text}}';
    // make POST request
    final response = await http.post(url, headers: headers, body: json);
  
  if(response.statusCode==400){
    print("fill in all the fields");
  }
  else if(response.statusCode==200){
    print("success");
  }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: appBarTitle,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 80, 30, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'InstaClone',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Divider(
                height: 35,
                color: Colors.red[600],
              ),
              Text(
                'Sign up to check out your feed!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        controller: usernameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        controller: usernameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Bio',
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        controller: bioController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.red[600],
                              child: FlatButton(
                                onPressed: null,
                                child: Text(
                                  'Done',
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
      ),
    );
  }
}
