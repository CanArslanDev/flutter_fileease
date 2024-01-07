class ConnectedUserModel {
  ConnectedUserModel({
    required this.token,
    required this.userID,
    required this.username,
  });

  String token;
  String userID;
  String username;

  Map<String, String> toMap() {
    return {
      'token': token,
      'userID': userID,
      'username': username,
    };
  }

  static ConnectedUserModel fromMap(Map<String, dynamic> map) {
    return ConnectedUserModel(
      token: map['token'] as String,
      userID: map['userID'] as String,
      username: map['username'] as String,
    );
  }
}
