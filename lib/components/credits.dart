import 'package:flutter/material.dart';

class CreditsPage extends StatefulWidget {
@override
_CreditsPageState createState() => new _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  Widget appBarTitle = new Text("Credits");
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicbgcolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Colors.black;
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          title:appBarTitle,
          
      ),
      
      backgroundColor: dynamicbgcolor,
      //no need of appbar for this page
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Center(
            child: ListView(
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
                  height: 25,
                  color: Colors.red[600],
                ),
                
                 Text(
                  'Instaclone is a limited feature yet working remake of Instagram .',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '\nDeveloped over a period of three days by\nteam Impractical Coders',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '.\nSuraj Kumar\nAakash Potepalli\nVridhi Kamath\nSoundarya\nSankalp Shanbhag\n.',
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
               
                
                SizedBox(
                  height: 60,
                ),
                
                Image(
                  image: AssetImage('assets/logo_dark.jpg'),
                  height: 150,
                  width: 150,
                ),
                /*RaisedButton(
                  child: Text("Signup page - soundarya"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}