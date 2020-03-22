class User {
  final String uid;
  final String username;
  final String profile_name;
  User({this.uid, this.profile_name, this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      username: json['username'],
      profile_name: json['profile_name'],
    );
  }
}
