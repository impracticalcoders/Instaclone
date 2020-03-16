import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String postimageurl;
  final String profileimageurl;
  final String profilename;

  PostCard({
    @required this.profilename,
    this.profileimageurl,
    this.postimageurl,
  });
  final String profiledefault =
      'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png';
  @override
  Widget build(BuildContext context) {
    return Card(
        color: (Theme.of(context).brightness != Brightness.dark)
            ? new Color(0xfff8faf8)
            : Colors.black,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
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
              Flexible(
                fit: FlexFit.tight,
                child: (postimageurl != null)
                    ? Image.network(
                        postimageurl,
                        //fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: 200,
                        height: 200,
                        child: Icon(Icons.error_outline)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Icon(
                          Icons.favorite_border,
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new Icon(
                          Icons.mode_comment,
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new Icon(Icons.share),
                      ],
                    ),
                    new Icon(Icons.bookmark_border)
                  ],
                ),
              ),

/*
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      
                      image:DecorationImage(image:  new NetworkImage(profileimageurl != null
                          ? 
                              profileimageurl
                              
                            
                          :  
                              'https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png',
                            
                            )
                          ,
                          )
                          ,
                    ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      profilename,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                )
              ]),
        ),
        Container(
          child: (postimageurl != null)
              ? Image.network(
                  postimageurl,
                  //fit: BoxFit.cover,
                )
              :SizedBox(width: 200, height: 200,child:Icon(Icons.error_outline)),
        ),
        Padding(
          padding: EdgeInsets.all(1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  //SizedBox(width: 16.0),
                  IconButton(
                    icon: Icon(Icons.mode_comment),
                    onPressed: () {},
                  ),
                  //SizedBox(width: 16.0),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    )
*/
            ]));
  }
}
