class Friend {
  final int id;
  final int fromUserId;
  final int toUserId;
  final String myEmail;
  final String friendEmail;
  final String friendName;

  Friend({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.myEmail,
    required this.friendEmail,
    required this.friendName,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      myEmail: json['myEmail'],
      friendEmail: json['friendEmail'],
      friendName: json['friendName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'myEmail': myEmail,
      'friendEmail': friendEmail,
      'friendName': friendName,
    };
  }
}
