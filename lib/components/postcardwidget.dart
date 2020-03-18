import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:async';

class PostCard extends StatefulWidget {
  final String postimageurl;
  final String profileimageurl;
  final String profilename;
  final String caption;
  int likes;
  final String id;
  final user;
  bool liked= false;
  
  PostCard({
    @required this.profilename,
    this.profileimageurl,
    this.postimageurl,
    this.likes,
    this.id,
    this.caption,
    @required this.user,
    this.liked
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {


  _likepostreq() async {
    //toggling like button
    if(widget.liked){
      setState(() {
        widget.likes= widget.likes-1;
        widget.liked = !widget.liked;
      });
    }
    else{
      setState(() {
        widget.likes= widget.likes+1;
        widget.liked = !widget.liked;
      });
    }

    // set up POST request arguments
    String url = 'http://fd8d89f0.ngrok.io/likes';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"id": "${widget.id}","uid" : "${this.widget.user.uid}"}';
    // make POST request
    final response = await http.post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    print("POST req response ${statusCode}");

    //no need to handle them
    // 203 - if the user has liked the post 
    // 204 - if the user has disliked the post (PS. don't know what say for unliking XD)
  
  }

  final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';

  @override
  Widget build(BuildContext context) {
    return/*  Container(
        color: (Theme.of(context).brightness != Brightness.dark)
            ? Colors.white
            : Colors.black,
        //elevation: 0.0, */
      
        //child:\
        Column(
          
          
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        new Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: new NetworkImage(
                                widget.profileimageurl != null
                                    ? widget.profileimageurl
                                    : profiledefault,
                              ),
                            ),
                          ),
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Text(
                          widget.profilename,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    new IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: null,
                    )
                  ],
                ),
              ),
              
                Container(
                 // height: 250,
                  child:                    Image.network(
                        widget.postimageurl,
                        fit: BoxFit.contain,
                      ),
                ),      
              
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        
                          new IconButton(
                           
                            icon: Icon(Icons.favorite_border),
                            color: widget.liked?Colors.red:Colors.black,
                          onPressed: (){
                            _likepostreq();
                          },
                          ),
                       
                        new IconButton(
                          icon : Icon( Icons.comment),
                          onPressed: (){
                            
                          },
                          ),
                        
                        new IconButton(
                          icon : Icon(FontAwesomeIcons.paperPlane),
                          onPressed: (){
                           
                          },
                          ),
                      ],
                    ),
                    new Icon(Icons.bookmark_border)
                  ],
                ),
              ),
            Text("  Liked by ${widget.likes} users"),
            SizedBox(height: 10,),
            Text("  @${widget.profilename} - \t\t${widget.caption}"),
            Divider(
                height: 30,
               
              ),
            ]
            //)
            );
  }
}
