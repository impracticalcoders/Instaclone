import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:dash_chat/dash_chat.dart';

class MyChatPage extends StatefulWidget {
  final int wsid;
  final String title;
  final String uid;
  final String profileName;
  final String profilePic;
  final String imageUrl;
  final user;
  MyChatPage({Key key, this.title,this.wsid,this.uid,this.profileName,this.profilePic,this.imageUrl,this.user}) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  int _counter = 0;
  List<ChatMessage> messages=[];
  final channel = IOWebSocketChannel.connect('wss://connect.websocket.in/v2/1?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImNmMTAxYmE0YzczOGQxZWVhNGM2YzExYTk4Y2NiYWE1YmU3M2QwOWNkNGZkODU2ZDY3NzE0ZjM2NDA5YTIxNDlhNWQ4ZmYwYzRkOGY3NjgxIn0.eyJhdWQiOiI4IiwianRpIjoiY2YxMDFiYTRjNzM4ZDFlZWE0YzZjMTFhOThjY2JhYTViZTczZDA5Y2Q0ZmQ4NTZkNjc3MTRmMzY0MDlhMjE0OWE1ZDhmZjBjNGQ4Zjc2ODEiLCJpYXQiOjE1ODQ3ODkxMjcsIm5iZiI6MTU4NDc4OTEyNywiZXhwIjoxNjE2MzI1MTI3LCJzdWIiOiI3MTAiLCJzY29wZXMiOltdfQ.IhB-_DZibdpGbMPUmxxSEn6FyHC4TvNLbiQz4Y6_eUHXooiPaeqnEjzzJWAiQhQASDA9b9Y0qhWy_TXYw17_Rcntj2INoY4ivCFBaET8oik-p4YwXB5eHuIFglNjNkkNZWbHlcsFkGe_JnnFiDT-Mnf4j62PnnA1Zm7Tx1PW6LwMghneSXORBmnUbZAlPO34LDm__QgLmE_u05ZubYOfwyDasT31j2zBtWaKhuw0NHYe0XA50czh8IUsGLbtJVxR_e294S7w1QnMB9Ava5AIgKmVVydTzPnMu60wZ8h10YceNkXlKDbik28Dk-pVePsUB_N1sV3H2wVF_BDIh0TupU_SGeh_0W12M_DaRv1hpu9kQby88drQn73VTbyFQKWQ-GgOGna7jGLVHT-ZRHr-bN4uWZ_2co74i8k_8EzpVsdwDsXF_BzUPVDYD1k2tvokKuPYQdiFcoJZEO8x48qPZdxJvlqdN0m63c6p9Y3eQHVYOkwW6if_O5ubJQ6uye5tZrRT_6rI7T4ias-Cl1IZFYSD6-KsZx5I5yGAyAVmu7MIMf_XJpLHjNf8kz50OfEJwncNoaOq6qd2WUiwajimOVyCqjfQkvI3ARk1ZlMkKJV9tvWYZPEx7JdFcAAAouOeWO7XnMvA3AKB7i6ijydltgDQs7Ya1CHancvJSxSAWgo');

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileName??"Suraj Kumar"),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircleAvatar(radius: 18,backgroundImage : NetworkImage(widget.profilePic??"https://avatars3.githubusercontent.com/u/37346450?s=460&v=4")),
        ),
      ),
      body: StreamBuilder(
        stream:this.channel.stream ,
        builder: (context,snapshot){
          if(snapshot.hasData){

            this.messages.add(
              ChatMessage(
                text: snapshot.data,
                user:ChatUser(
                  name: widget.profileName??"Arvind",
                  uid:widget.uid??"123",
                  avatar:widget.profilePic?? "https://avatars3.githubusercontent.com/u/37346450?s=460&v=4",
                  ),
                image: widget.imageUrl ,
                ));
          }

            return DashChat(
              showUserAvatar: true,
              messages: this.messages, 
               inputMaxLines: 5,
              messageContainerDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.blue,
              ),
              onSend: (ChatMessage ) {
                this.channel.sink.add(ChatMessage.text);

                this.messages.add(ChatMessage);
              }, 
              timeFormat: DateFormat.Hm(),
              //leading: <Widget>[Container(width: 20,)],
              inputToolbarMargin: EdgeInsets.all(15),
              user: ChatUser(name: widget.profileName ?? "Aakash",uid:"10",avatar:widget.profilePic?? "https://media-exp1.licdn.com/dms/image/C5103AQHJ6oyTDlXPUg/profile-displayphoto-shrink_200_200/0?e=1586995200&v=beta&t=ItU48T4oHQ1Qqr5rt1jWysMW134E1Tp2K40RBoBni2M"),
              inputToolbarPadding: EdgeInsets.only(left:12),
              inputContainerStyle: BoxDecoration(
                border:Border.all(color: Colors.grey),
                
                //color: Colors.white,
                borderRadius:BorderRadius.all(Radius.circular(30)),
              ),
              inputTextStyle:TextStyle(fontSize: 20) 
              );

         
          
        },)
    );
  }
}
