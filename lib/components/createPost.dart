import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CreatePost extends StatefulWidget {


  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File _image;
  String imageID="";
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxHeight: 500, maxWidth: 500);

    setState(() {
      this._image = image;
    });
  }

  _createPostRequest() async{
    
  }

  _uploadImage() async{
    
    Dio dio = new Dio();

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        this._image.path,
        filename: "createFeed",
      ),
   });
     await dio.post("https://73ed7582.ngrok.io/images", data: data).then((response) => print(response));
      
     }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("create new post"),),
      body:  Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Caption"),
                    autocorrect: false,
                  ),
                  RaisedButton(
                    onPressed: getImage,
                    child: Icon(Icons.add_a_photo),
                  ),
                  Container(
                    child:_image == null
                      ? Text('No image selected.')
                      : Image.file(_image,height: 300,),),
                  RaisedButton(
                    child:Text("Post"),
                    onPressed:_uploadImage
                     ,),
                  
                ],),
            ),
          ),)
      );

  }
}