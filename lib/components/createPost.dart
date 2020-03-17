import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

import 'mainfeed.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File _image;
  String imageUrl = "";
  bool isImageUploading = false;
  bool isPosting = false;
  TextEditingController captionController = TextEditingController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);

    setState(() {
      this._image = image;
    });
    _uploadImage();
  }

  _createPostRequest() async {
    if (!this.isImageUploading) {
      setState(() {
        this.isPosting = true;
      });

      final response = await http.post(
          "https://insta-clone-backend.now.sh/feed",
          headers: {"Content-type": "application/json"},
          body:
              '{"caption":"${captionController.text}","post_pic":"${this.imageUrl}","username":"dummy","profile_name":"dummy"}');

      print("Status code ${response.statusCode}");

      if (response.statusCode == 200) {
        var snackbar = new SnackBar(content: new Text("Posted!"));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      } else if (response.statusCode == 400) {
        var snackbar =
            new SnackBar(content: new Text("Image/Caption not added"));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      } else {
        var snackbar = new SnackBar(
            content: new Text(
                "There has been a problem uploading your post . Try again later"));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
      setState(() {
        this.isPosting = false;
      });
    } else {
      var snackbar = new SnackBar(
          content: new Text("Please wait while the image is uploading!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  _uploadImage() async {
    setState(() {
      this.isImageUploading = true;
    });
    String randomString = randomAlphaNumeric(10);

    StorageReference ref =
        FirebaseStorage.instance.ref().child('images/' + randomString + '.png');
    StorageUploadTask task = ref.putFile(this._image);
    StorageTaskSnapshot downloadUrl = (await task.onComplete);
    String url = (await downloadUrl.ref.getDownloadURL());

    setState(() {
      this.imageUrl = url;
      this.isImageUploading = false;
    });

    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "New Post",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                height: 35,
                color: Colors.red[600],
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: _image == null
                              ? FlatButton(
                                  onPressed: getImage,
                                  child: SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: Icon(Icons.add_a_photo),
                                  ),
                                )
                              : Image.file(
                                  _image,
                                  height: 300,
                                ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Caption"),
                          autocorrect: false,
                          controller: captionController,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        RaisedButton(
                          child: Text("Post"),
                          onPressed:
                              this.isPosting ? () {} : _createPostRequest,
                        ),
                        Container(
                          child: this.isPosting
                              ? CircularProgressIndicator()
                              : Text(""),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
