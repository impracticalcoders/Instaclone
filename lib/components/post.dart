

class Post {
  final String post_pic;
  final String profile_name;
  final String username;
  final String caption;
  final int likes;
  final String id;

  Post({this.post_pic, this.profile_name, this.username,this.likes,this.id,this.caption});

  factory Post.fromJson(Map<String,dynamic> json) {
    return Post(
      id: json['id'],
      post_pic: json['post_pic'],
      profile_name: json['profile_name'],
      username: json['username'],
      likes: json['likes'],
      caption: json['caption'],
    );
  }
}
