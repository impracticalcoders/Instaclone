import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatefulWidget {
@override
_CreditsPageState createState() => new _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  Widget appBarTitle = new Text("Credits");
  Icon actionIcon = new Icon(Icons.search);
_launchURL() async {
  const url = 'mailto:<codersimpractical@gmail.com>';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_launchAPKdownload() async {
  const url = 'https://bit.ly/instaclone1';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String logourl=(isDarkMode)?'assets/TeamIC1.png':'assets/TeamIC2.png';
    List<String> developers =["Suraj Kumar","Aakash Pothepalli","Vridhi Kamath","Soundarya","Sankalp Shanbhag"];
    developers.shuffle();
    String namelist="";
    for(int i= 0;i<developers.length;i++){
      namelist+="\n"+developers[i];
    }
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicbgcolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Colors.black;
        Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          title:appBarTitle,
          backgroundColor: dynamicuicolor,
          actions: <Widget>[
            IconButton(
                    onPressed:_launchAPKdownload,
                    icon: Icon(Icons.system_update_alt,semanticLabel: "Update",),
                    color: Colors.green,
                    splashColor: Colors.white,
                    //iconSize: 40,
                    
                    tooltip: "Download the latest apk",)
          ],
      ),
      
      backgroundColor: dynamicbgcolor,
      //no need of appbar for this page
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
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
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 25,
                  color: Colors.red[600],
                ),
                
                 Text(
                  'Instaclone is a limited feature working remake of Instagram .',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '\nDeveloped in 10 days by\nteam Impractical Coders',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '.${namelist}\n.',
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
                Center(
                  child: Text(
                    'Tech Stack.',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Billabong',
                      
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  height: 25,
                  color: Colors.red[600],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Image.asset('assets/flutterlogo.png',width: 150,height: 100,)),
                    Expanded(child:Image.network("https://pluralsight.imgix.net/paths/path-icons/nodejs-601628d09d.png",cacheWidth: 150,))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child:Image.network("https://img.icons8.com/color/480/firebase.png",cacheWidth: 100,)),
                    Expanded(child:Image.network("https://logowiki.net/wp-content/uploads/imgp/WebSocket-Logo-1-5136.gif",cacheWidth: 140,))
                  ],
                ),
                 Row(
                  children: <Widget>[
                    Expanded(child:Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Android_Studio_icon.svg/1200px-Android_Studio_icon.svg.png",cacheWidth: 100,)),
                    Expanded(child:Image.network("https://user-images.githubusercontent.com/10379994/31985754-c56b8dba-b998-11e7-9705-a7f984433049.png",cacheWidth: 120,))
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
               Center(
                  child: Text(
                    'Contact us',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Billabong',
                       
                    
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                   Divider(
                  height: 25,
                  color: Colors.red[600],
                ),
                Center(
                  child: Text(
                    'We are looking for internships\nSend us a mail at\ncodersimpractical@gmail.com\nor tap the button below',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Pacifico',
                       fontWeight: FontWeight.w300,
                    color: dynamiciconcolor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                  height: 10,
                ),
             Center(
                  child: IconButton(
                    onPressed:_launchURL,
                    icon: Icon(Icons.mail,semanticLabel: "Mail us",),
                    color: Colors.green,
                    splashColor: Colors.white,
                    iconSize: 40,
                    
                    tooltip: "Send an email to Impractical Coders",)
                ),
                
                Divider(
                  height: 25,
                  color: Colors.red[600],
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