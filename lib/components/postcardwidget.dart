import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';

class PostCard extends StatefulWidget {
  final String postimageurl;
  final String profileimageurl;
  final String profilename;
  final String caption;
  int likes;
  final String id;
  final user;
  bool liked = false;
  final String username;

  PostCard(
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
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final FlareControls flareControls = FlareControls();
  @override
  Future<void> _shareText() async {
    try {
      Share.text('my text title',
          'This is my text to share with other applications.', 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

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
  }

  final String profiledefault =
      'gs://instaclone-63929.appspot.com/Deafult-Profile-Picture.png';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black54 : Colors.white70;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(35, 35, 35, 1.0);
    return Card(
      color: (!isDarkMode) ? Colors.white : Colors.black,
      elevation: 0.1,
      child: 
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
        GestureDetector(
          onDoubleTap: () {
            _likepostreq();
            flareControls.play("like");
          },
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  // height: 250,
                  child: Image.network(
                    widget.postimageurl,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                //height: 200,
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
                    icon: widget.liked
                        ? Icon(Icons.favorite, size: 28)
                        : Icon(Icons.favorite_border, size: 28),
                    color: widget.liked
                        ? Colors.red
                        : (isDarkMode) ? Colors.white : Colors.black,
                    onPressed: () {
                      _likepostreq();
                    },
                  ),
                  new IconButton(
                    icon: Icon(FontAwesomeIcons.comment),
                    onPressed: () {},
                  ),
                  new IconButton(
                      icon: Icon(FontAwesomeIcons.paperPlane),
                      onPressed: () async => await _shareImageFromUrl()),
                ],
              ),
              new Icon(
                Icons.bookmark_border,
                size: 28,
              )
            ],
          ),
        ),
        Text("  Liked by ${widget.likes} users"),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Text(
              "  @${widget.username}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("\t${widget.caption}"),
          ],
        ),
        Divider(
          height: 30,
        ),
      ],
      )
    );
  }
}
