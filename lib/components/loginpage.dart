import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  @override


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);

    return Scaffold(
      //no need of appbar for this page
      body: Padding(
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
              Text(
                'Login to check out your feed!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: dynamiciconcolor,
                ),
              ),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: dynamiciconcolor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: dynamiciconcolor,
                          ),
                        ),
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
                                  'Login!',
                                  style: TextStyle(
                                    color: dynamiciconcolor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: FlatButton(
                                  onPressed: null,
                                  child: Text(
                                    'Forgot password or username',
                                    style: TextStyle(
                                      color: Colors.red[600],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'New to Instaclone?',
                                  style: TextStyle(
                                    color: dynamiciconcolor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FlatButton(
                                  onPressed: null,
                                  child: Text(
                                    'SignUp!',
                                    style: TextStyle(
                                      color: Colors.red[600],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
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
              SizedBox(
                height: 10,
              ),
              Image(image: 
              AssetImage('assets/Team_IC.jpg'),height: 150,width: 150,),
            ],
          ),
        ),
      ),
    );
  }
}
