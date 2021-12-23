import 'dart:async';
import 'dart:convert';
import 'package:Instaclone/components/Chat/myChatPage.dart';
import 'package:Instaclone/components/mainfeed.dart';
import 'package:Instaclone/main1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class ChatsPage extends StatefulWidget {
  User user;
  ChatsPage(this.user);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  StreamController _usersController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var channel =
      IOWebSocketChannel.connect('wss://instaclonebackendrit.herokuapp.com');

  @override
  void initState() {
    _usersController = new StreamController();
    loadChats();

    super.initState();
  }

  fetchUsers() async {
    final response = await http
        .get(Uri.parse('https://instacloneproduction.glitch.me/users'));
    // var users = json.decode(response.body) ;
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } // var users = json.decode(response.body) ;

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

  showSnack(text) {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    fetchUsers().then((res) async {
      _usersController.add(res);
      showSnack('New content loaded');
      return null;
    });
  }

  Future<bool> _onPressBack() async {
    this.channel.sink.close();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    this.channel.sink.add('{"uid":"${widget.user.uid}","type":"init"}');

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    return WillPopScope(
      onWillPop: _onPressBack,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Direct'),
          backgroundColor: dynamicuicolor,
          actions: <Widget>[
            // Icon(Icons.message),
            IconButton(
              icon: Icon(
                Icons.info,
              ),
              onPressed: () {
                showSnack('DM will work only if both the users are online');
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _usersController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // print('Has error: ${snapshot.hasError}');
            // print('Has data: ${snapshot.hasData}');
            // print('Snapshot Data ${snapshot.data}');

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
                            if (user['uid'] != widget.user.uid) {
                              return ChatWidget(
                                profileName:
                                    user['profile_name'] ?? "Anonymous",
                                profilePic: user['profile_pic'] ??
                                    "https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png",
                                subTitle: "Start a conversation",
                                chatUserUid: user['uid'],
                                user: widget.user,
                              );
                            } else
                              return Container();
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
            return Container();
          },
        ),
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  String profileName;
  String profilePic;
  String subTitle;
  String chatUserUid;
  User user;

  ChatWidget(
      {this.profileName,
      this.profilePic,
      this.subTitle,
      this.chatUserUid,
      this.user});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(this.profilePic)),
      title: Text(this.profileName),
      subtitle: Text(this.subTitle),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyChatPage(
                      profileName: this.profileName,
                      profilePic: this.profilePic,
                      uid: this.chatUserUid,
                      user: this.user,
                    )));
      },
    );
  }
}
