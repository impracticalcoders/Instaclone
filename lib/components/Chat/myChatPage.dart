import 'dart:convert';

import 'package:Instaclone/main1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:web_socket_channel/io.dart';
import 'package:dash_chat/dash_chat.dart';

class MyChatPage extends StatefulWidget {
  final String uid;
  final String profileName;
  final String profilePic;
  final user;
  MyChatPage({ this.uid,this.profileName,this.profilePic,this.user}) ;

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  int _counter = 0;
  List<ChatMessage> messages=[];
   var channel = IOWebSocketChannel.connect('wss://aakash9518-instaclone-backend.glitch.me');

  
  @override
  void initState() { 
    super.initState();
  }



  Future<bool> _onPressBack() async{
      await this.channel.sink.close();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
      return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onPressBack ,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.profileName??"Suraj Kumar",),
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(radius: 18,backgroundImage : NetworkImage(widget.profilePic??"https://avatars3.githubusercontent.com/u/37346450?s=460&v=4")),
          ),
          backgroundColor: Colors.white70,
        ),
        body: StreamBuilder(
          stream:this.channel.stream ,
          builder: (context,snapshot){
            if(snapshot.hasData){
                this.channel.sink.add('{"uid":"${widget.user.uid}","type":"init"}');
              print(snapshot.data);
              var message= json.decode(snapshot.data)["message"];
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

              return DashChat(
                
                showUserAvatar: true,

                messages: this.messages, 
                 inputMaxLines: 5,
                
                onSend: (ChatMessage ) {
                  this.channel.sink.add('{"type":"message","in_uid":"${widget.user.uid}","dest_uid":"${widget.uid}","message":"${ChatMessage.text}"}');

                  this.messages.add(ChatMessage);
                }, 
                timeFormat: DateFormat.Hm(),
                //leading: <Widget>[Container(width: 20,)],
                inputToolbarMargin: EdgeInsets.all(15),
                user: ChatUser(
                  name: widget.user.displayName,
                  uid:widget.user.uid,
                  avatar:widget.user.photoUrl),

                inputToolbarPadding: EdgeInsets.only(left:12),
                inputContainerStyle: BoxDecoration(
                  border:Border.all(color: Colors.grey),
                  
                  //color: Colors.white,
                  borderRadius:BorderRadius.all(Radius.circular(30)),
                ),
                inputTextStyle:TextStyle(fontSize: 20) 
                );

           
            
          },)
      ),
    );
  }
}
