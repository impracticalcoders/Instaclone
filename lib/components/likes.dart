

class Like {
  final String activity_text;
  final String post_pic;
  final String uid;
  

  Like({this.activity_text, this.post_pic,this.uid});

  factory Like.fromJson(Map<String,dynamic> json) {
    return Like(
      activity_text: json['activity_text'],
      post_pic: json['post_pic'],
      uid: json['uid'],
    );
  }
}
