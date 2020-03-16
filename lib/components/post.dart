

class Post {
  final String post_pic;
  final String profile_name;
  final String username;

  Post({this.post_pic, this.profile_name, this.username});

  factory Post.fromJson(Map<String,dynamic> json) {
    return Post(
      post_pic: json['post_pic'],
      profile_name: json['profile_name'],
      username: json['username'],
    );
  }
}
