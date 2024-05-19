class Sms {
  String? receiverNumber;
  String? userName;
  String? challengeName;
  String? relationship;
  String? receiverName;
  String? letter;

  Sms({
    required this.receiverNumber,
    required this.userName,
    required this.challengeName,
    required this.relationship,
    required this.receiverName,
    required this.letter,
  });

  Sms.fromJson(Map<String, dynamic> json) {
    receiverNumber = json['receiverNumber'];
    userName = json['userName'];
    challengeName = json['challengeName'];
    relationship = json['relationship'];
    receiverName = json['receiverName'];
    letter = json['letter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['receiverNumber'] = receiverNumber;
    data['userName'] = userName;
    data['challengeName'] = challengeName;
    data['relationship'] = relationship;
    data['receiverName'] = receiverName;
    data['letter'] = letter;
    return data;
  }
}
