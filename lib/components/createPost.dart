import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:instaclone/main1.dart';

import 'mainfeed.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  XFile _image;
  String imageUrl = "";
  bool isImageUploading = false;
  bool isPosting = false;
  TextEditingController captionController = TextEditingController();
  User user;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  User getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    var user = getUser();
    setState(() {
      this.user = user;
    });
  }

  Future getImage() async {
    User user = getUser();
    if (user == null) {
      var snackbar = new SnackBar(
          content: new Text("Please Login/Signup before posting!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      var image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
          maxHeight: 500,
          maxWidth: 500);

      setState(() {
        this._image = image;
      });
      _uploadImage();
    }
  }

  _createPostRequest() async {
    if (!this.isImageUploading) {
      setState(() {
        this.isPosting = true;
      });
//https://insta-clone-backend.now.sh
      final response = await http.post(
          Uri.parse("https://instaclonebackendrit.herokuapp.com/feed"),
          headers: {"Content-type": "application/json"},
          body:
              '{"caption":"${captionController.text}","image_url":"${this.imageUrl}","uid":"${this.user.uid}"}');

      print("Status code ${response.statusCode}");

      if (response.statusCode == 200) {
        var snackbar = new SnackBar(content: new Text("Posted!"));
        _scaffoldKey.currentState.showSnackBar(snackbar);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
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

    // StorageReference ref =
    //     FirebaseStorage.instance.ref().child('images/' + randomString + '.png');
    // StorageUploadTask task = ref.putFile(this._image);
    // StorageTaskSnapshot downloadUrl = (await task.onComplete);
    // String url = (await downloadUrl.ref.getDownloadURL());

    // setState(() {
    //   this.imageUrl = url;
    //   this.isImageUploading = false;
    // });

    // print(url);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color dynamiciconcolor = (!isDarkMode) ? Colors.black : Colors.white;
    Color dynamicuicolor =
        (!isDarkMode) ? new Color(0xfff8faf8) : Color.fromRGBO(25, 25, 25, 1.0);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: (!isDarkMode) ? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor: dynamicuicolor,
        centerTitle: true,
        title: Text("New Post"),
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
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
                              File(_image.path),
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
                      onPressed: this.isPosting ? () {} : _createPostRequest,
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
          )),
    );
  }
}
