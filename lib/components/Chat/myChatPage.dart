import 'dart:convert';

import 'package:Instaclone/main1.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:dash_chat/dash_chat.dart';

class MyChatPage extends StatefulWidget {
  final String uid;
  final String profileName;
  final String profilePic;
  final user;
  MyChatPage({this.uid, this.profileName, this.profilePic, this.user});

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  int _counter = 0;
  List<ChatMessage> messages = [];

  var channel = IOWebSocketChannel.connect(
      'wss://instacloneproduction.glitch.me');

  @override
  void initState() {
   
    super.initState();
  }

  Future<bool> _onPressBack() async {
    await this.channel.sink.close();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
      this.channel.sink.add('{"uid":"${widget.user.uid}","type":"init"}');

     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white;
    Color dynamicuicolor =(!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    return WillPopScope(
      onWillPop: _onPressBack,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(widget.profilePic ??
                          "https://avatars3.githubusercontent.com/u/37346450?s=460&v=4")),
                ),
                SizedBox(width: 10,),
                Text(
                  widget.profileName ?? "Suraj Kumar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            backgroundColor: dynamicuicolor,
          ),
          backgroundColor: dynamicuicolor,
      
        body: StreamBuilder(
          stream:this.channel.stream ,
          builder: (context,snapshot){
            if(snapshot.hasData){
              print(snapshot.data);
                var data = json.decode(snapshot.data);

              if((data['type']=="message" && data['in_uid']==widget.uid) || (data['type']=="offline"&& data['dest_uid']==widget.uid)){   

                print(snapshot.data);
                var message= data["message"];
                this.messages.add(
                  ChatMessage(
                    text: message,
                    user:ChatUser(
                      name: widget.profileName,
                      uid:widget.uid,
                      avatar:widget.profilePic,
                      ),
                    ));

                }
                
            }
              return DashChat(
                  //showUserAvatar: true,
                  messages: this.messages,
                  inputMaxLines: 5,
                  showAvatarForEveryMessage: false,
                  onSend: (ChatMessage) {
                    this.channel.sink.add(
                        '{"type":"message","in_uid":"${widget.user.uid}","dest_uid":"${widget.uid}","message":"${ChatMessage.text}"}');

                    this.messages.add(ChatMessage);
                  },
                  timeFormat: DateFormat.Hm(),
                  //leading: <Widget>[Container(width: 20,)],
                  inputToolbarMargin: EdgeInsets.only(left:15,right: 15,bottom: 15),
                  user: ChatUser(
                      name: widget.user.displayName,
                      uid: widget.user.uid,
                      avatar: widget.user.photoUrl),
                  inputToolbarPadding: EdgeInsets.only(left: 12),
                  inputContainerStyle: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  
                    //color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  
                  //chatFooterBuilder: , //for the 'typing' message
                  inputTextStyle: TextStyle(fontSize: 15));
            },
          )),
    );
  }
}
