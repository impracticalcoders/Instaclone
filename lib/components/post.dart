class Post {
  final String post_pic;
  final String profile_name;
  final String username;
  final String caption;
  final int likes;
  final String id;
  final String uid;
  bool liked;
  final String profile_pic;
  Post(
      {this.post_pic,
      this.profile_name,
      this.username,
      this.likes,
      this.id,
      this.caption,
      this.liked,
      this.profile_pic,
      this.uid});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      post_pic: json['image_url'],
      profile_name: json['profile_name'],
      username: json['username'],
      likes: json['likes'],
      caption: json['caption'],
      liked: json['liked'] ?? false,
      profile_pic: json['profile_pic'],
      uid: json['uid'],
    );
  }
}
