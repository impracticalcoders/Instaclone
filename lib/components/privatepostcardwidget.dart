import 'package:Instaclone/components/profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
//import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class PrivatePostCard extends StatefulWidget {
  final String postimageurl;
  final String profileimageurl;
  final String profilename;
  final String caption;
  int likes;
  final String id;
  final user;
  bool liked = false;
  final String username;

  PrivatePostCard(
      {@required this.profilename,
      this.username,
      this.profileimageurl,
      this.postimageurl,
      this.likes,
      this.id,
      this.caption,
      @required this.user,
      this.liked});

  @override
  _PrivatePostCardState createState() => _PrivatePostCardState();
}

class _PrivatePostCardState extends State<PrivatePostCard> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final FlareControls flareControls = FlareControls();
  @override
  Future<void> _shareImageFromUrl() async {
    try {
      var request =
          await HttpClient().getUrl(Uri.parse('${widget.postimageurl}'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('InstaClone ${widget.profilename}',
          'instaclone_post_${widget.profilename}.jpg', bytes, 'image/jpg',
          text: 'Check out ${widget.profilename}\'s post on Instaclone');
    } catch (e) {
      print('error: $e');
    }
  }

/*
  _likepostreq() async {
    //toggling like button
    if (widget.liked) {
      setState(() {
        widget.likes = widget.likes - 1;
        widget.liked = !widget.liked;
      });
    } else {
      setState(() {
        widget.likes = widget.likes + 1;
        widget.liked = !widget.liked;
      });
    }
//https://insta-clone-backend.now.sh

    // set up POST request arguments
    String url = 'https://insta-clone-backend.now.sh/likes';
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
  }*/

  _deletepostreq() async {
    //https://insta-clone-backend.now.sh

    // set up POST request arguments
    String url = 'https://instaclonebackendrit.herokuapp.com/delete_post';
    Map<String, String> headers = {"Content-type": "application/json"};
    print(
        "Delete requested for post_id${this.widget.id} by Uid: ${this.widget.user.uid}");
    String json =
        '{"post_id": "${this.widget.id}","uid" : "${this.widget.user.uid}"}';
    // make POST request
    final response =
        await http.post(Uri.parse(url), headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    print("POST delete req response ${statusCode}");
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      //TODO: implement usermismatch error
    }
  }

  final String profiledefault =
      'https://firebasestorage.googleapis.com/v0/b/instaclone-63929.appspot.com/o/Deafult-Profile-Picture.png?alt=media&token=9a731929-a94c-4ce9-b77c-db317fa6148e';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 4.0),
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
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                            title: Text("More Options"),
                            //message: const Text(''),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                child: const Text('Delete Post'),
                                onPressed: _deletepostreq,
                              ),
                            ],

                            cancelButton: CupertinoActionSheetAction(
                              child: const Text('Cancel'),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                            ),
                          ));
                },
              )
            ],
          ),
        ),
        /*GestureDetector(
            onDoubleTap: () {
              _likepostreq();
              flareControls.play("like");
            },
            child: Stack(
              children: <Widget>[
                Center(
                  child:*/
        Container(
          // height: 250,
          child: Image.network(
            widget.postimageurl,
            fit: BoxFit.contain,
          ),
        ),
        /*   ),
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: FlareActor(
                        'assets/instagram_like.flr',
                        controller: flareControls,
                        animation: 'idle',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /*  new IconButton(
                      icon: widget.liked
                          ? Icon(Icons.favorite, size: 28)
                          : Icon(Icons.favorite_border, size: 28),
                      color: widget.liked
                          ? Colors.red
                          : (isDarkMode) ? Colors.white : Colors.black,
                      onPressed: () {
                       _likepostreq();
                      },
                    ),*/

                  /* new IconButton(
                        icon: Icon(FontAwesomeIcons.paperPlane),
                        onPressed: () async => await _shareImageFromUrl()),*/
                ],
              ),
              IconButton(
                  icon: Icon(FontAwesomeIcons.paperPlane),
                  onPressed: () async => await _shareImageFromUrl()),
            ],
          ),
        ),
        Text("  Liked by ${widget.likes} users"),
        SizedBox(
          height: 10,
        ),
        Wrap(
          children: <Widget>[
            RichText(
                text: TextSpan(
                    // set the default style for the children TextSpans
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 15),
                    children: [
                  TextSpan(
                    text: "  @${widget.username}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\t${widget.caption}",
                  ),
                ])),
          ],
        ),
        Divider(
          height: 30,
        ),
      ],
      //)
    );
  }
}
