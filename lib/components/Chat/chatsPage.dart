import 'dart:async';
import 'dart:convert';
import 'package:Instaclone/components/Chat/myChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatsPage extends StatefulWidget {
  FirebaseUser user;
  ChatsPage(this.user);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  StreamController _usersController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() { 
    _usersController = new StreamController();
    loadChats();
    super.initState();
    
  }

  fetchUsers() async {
    final response = await http.get('https://insta-clone-backend.now.sh/users');
    // var users = json.decode(response.body) ;
    if(response.statusCode==200){
      return json.decode(response.body);
    }    // var users = json.decode(response.body) ;

    else {
      print("Cannot load users");
    }
  }
  

  loadChats() async {
    fetchUsers().then((res) async {
      _usersController.add(res);
      return res;
    });
  }


  showSnack() {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('New content loaded'),
      ),
    );
  }
  Future<Null> _handleRefresh() async {
    fetchUsers().then((res) async {
      _usersController.add(res);
      showSnack();
      return null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Direct'),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Icon(Icons.message)
        ],
      ),
      body: StreamBuilder(
        stream: _usersController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print('Has error: ${snapshot.hasError}');
          print('Has data: ${snapshot.hasData}');
          print('Snapshot Data ${snapshot.data}');

          if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var user = snapshot.data[index];
                          if(user['uid']!= widget.user.uid){
                            return ChatWidget(
                              profileName:user['profile_name'] ,
                              profilePic: user['profile_pic'],
                              subTitle: "text here",
                              chatUserUid: user['uid'],
                              user: widget.user,);
                            }
                          else return Container();
                        
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Text('No Posts');
          }
        },
        ),
    );
  }
}

class ChatWidget extends StatelessWidget{

  String profileName;
  String profilePic;
  String subTitle;
  String chatUserUid;
  FirebaseUser user;

  ChatWidget({this.profileName,this.profilePic,this.subTitle,this.chatUserUid,this.user});
  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading:CircleAvatar(backgroundImage: NetworkImage(this.profilePic)) ,
      title: Text(this.profileName),
      subtitle: Text(this.subTitle),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
          MyChatPage(
            profileName: this.profileName,
            profilePic: this.profilePic,
            uid: this.chatUserUid,
            user: this.user,)));
      },
      );
  }
  
} 