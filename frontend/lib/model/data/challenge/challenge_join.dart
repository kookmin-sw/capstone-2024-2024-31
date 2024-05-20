class ChallengeJoin {
  String? targetName;
  String? receiverNumber;
  String? determination;

  ChallengeJoin({
    this.targetName,
    this.receiverNumber,
    this.determination,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['targetName'] = targetName;
    data['receiverName'] = receiverNumber;
    data['determination'] = determination;
    return data;
  }
}
