class ChallengeSimple {
  final int id;
  final String startDate;
  final String challengeName;
  final String certificationFrequency;
  final int challengePeriod;
  final int totalParticipants;
  final String imageUrl;
  final String status;
  final bool isPrivate;

  ChallengeSimple({
    required this.id,
    required this.startDate,
    required this.challengeName,
    required this.certificationFrequency,
    required this.challengePeriod,
    required this.totalParticipants,
    required this.imageUrl,
    required this.status,
    required this.isPrivate,
  });

  factory ChallengeSimple.fromJson(Map<String, dynamic> json) {
    return ChallengeSimple(
      id: json['id'],
      startDate: json['startDate'],
      challengeName: json['challengeName'],
      certificationFrequency: json['certificationFrequency'],
      challengePeriod: json['challengePeriod'],
      totalParticipants: json['totalParticipants'],
      imageUrl: json['imageUrl'],
      status: json['status'],
      isPrivate: json['isPrivate'],
    );
  }


  // 객체에서 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeName': challengeName,
      'startDate': startDate.toIso8601String(),
      'challengePeriod': challengePeriod,
      'certificationFrequency': certificationFrequency,
      'totalParticipants': totalParticipants,
      'imageUrl': imageUrl,
      'status': status,
      'isPrivate': isPrivate,
    };
  }
}

void main() {
  // JSON 데이터 예시
  String jsonData = '''
  {
    "id": 1,
    "challengeName": "Sample Challenge",
    "startDate": "2024-05-16",
    "challengePeriod": 30,
    "certificationFrequency": "daily",
    "totalParticipants": 100,
    "imageUrl": "http://example.com/image.jpg",
    "status": "ongoing",
    "isPrivate": false
  }
  ''';

  // JSON을 객체로 변환
  Map<String, dynamic> jsonMap = jsonDecode(jsonData);
  ChallengeSimple challenge = ChallengeSimple.fromJson(jsonMap);

  // 객체를 JSON으로 변환
  String jsonString = jsonEncode(challenge.toJson());

  print(jsonString);
}
