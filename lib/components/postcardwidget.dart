import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PostCard extends StatelessWidget {
  final String postimageurl;
  final String profileimageurl;
  final String profilename;
  final String caption;
  int likes;
  final String id;

  PostCard({
    @required this.profilename,
    this.profileimageurl,
    this.postimageurl,
    this.likes,
    this.id,
    this.caption,
  });

  
  _likepostreq() async {
  // set up POST request arguments
  String url = 'https://insta-clone-backend.now.sh/likes';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"id": "${id}", "oper": "+"}';
  // make POST request
  final response = await http.post(url, headers: headers, body: json);
  // check the status code for the result
  int statusCode = response.statusCode;
  print("POST req response ${statusCode}");
  
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
                                profileimageurl != null
                                    ? profileimageurl
                                    : profiledefault,
                              ),
                            ),
                          ),
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Text(
                          profilename,
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
                        postimageurl,
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
                          icon : Icon( Icons.share),
                          onPressed: (){
                           
                          },
                          ),
                      ],
                    ),
                    new Icon(Icons.bookmark_border)
                  ],
                ),
              ),
            Text("  Liked by ${likes} users"),
            SizedBox(height: 10,),
            Text("  @${profilename} - \t\t${caption}"),
            Divider(
                height: 30,
               
              ),
            ]
            //)
            );
  }
}
