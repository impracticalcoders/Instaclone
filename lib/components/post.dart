

class Post {
  final String post_pic;
  final String profile_name;
  final String username;

  Post({this.post_pic, this.profile_name, this.username});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      post_pic: json['main_feed']['a1']['post_pic'],
      profile_name: json['main_feed']['a1']['profile_name'],
      username: json['main_feed']['a1']['username'],
    );
  }
}
