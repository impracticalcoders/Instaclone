

class Post {
  final String post_pic;
  final String caption;
  final int likes;
  Post({this.post_pic,this.likes,this.caption});

  factory Post.fromJson(Map<String,dynamic> json) {
    return Post(
  
      post_pic: json['post_pic'],

      likes: json['likes'],
      caption: json['caption'],

      
    );
  }
}


class Userdetails {
  final String profile_name;
  final String username;



  final String uid;
  List<Post> posts;

  final String bio;
  final String profile_pic;
  Userdetails(this.bio, this.profile_name, this.username,this.profile_pic,this.uid,[this.posts]);

  factory Userdetails.fromJson(dynamic json) {
    if (json['posts'] != null) {
      var postObjsJson = json['posts'] as List;
      List<Post> _posts = postObjsJson.map((postJson) => Post.fromJson(postJson)).toList();

      return Userdetails(
        json['bio'] as String,json['profile_name'] as String,json['username'] as String,json['profile_pic'] as String,json['uid'] as String,
        _posts
      );
    } 


/*
    return Userdetails(
      profile_name: json['profile_name'],
      username: json['username'],
      posts:Post.fromJson(json['posts']),
      profile_pic:json['profile_pic'],
      uid: json['uid'],
      
    );*/
  }
}
