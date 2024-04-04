
class Challenge {

  late int challengeId;

  late String challengeName;
  late DateTime? startDate;
  late DateTime? endDate;
  late int? certificationFrequency;
  late String? certificationExplanation;
  late int? certificationCount;
  late String? certificationMethod;
  late String? challengeExplanation;
  late int? maximumPeople;
  late bool? isPrivate;
  late String? privateCode;

  late List<Participant> participants;

  Challenge();

  Challenge.builder({
    required this.challengeName,
    required this.startDate,
    required this.endDate,
    required this.certificationFrequency,
    required this.certificationExplanation,
    required this.certificationCount,
    required this.certificationMethod,
    required this.challengeExplanation,
    required this.maximumPeople,
    required this.isPrivate,
    required this.privateCode,
    required this.participants,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge.builder(
      challengeName: json['challenge_name'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      certificationFrequency: json['certification_frequency'],
      certificationExplanation: json['certification_explanation'],
      certificationCount: json['certification_count'],
      certificationMethod: json['certification_method'],
      challengeExplanation: json['challenge_explanation'],
      maximumPeople: json['maximum_people'],
      isPrivate: json['is_private'],
      privateCode: json['private_code'],
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => Participant.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge_name': challengeName,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'certification_frequency': certificationFrequency,
      'certification_explanation': certificationExplanation,
      'certification_count': certificationCount,
      'certification_method': certificationMethod,
      'challenge_explanation': challengeExplanation,
      'maximum_people': maximumPeople,
      'is_private': isPrivate,
      'private_code': privateCode,
      'participants': participants.map((e) => e.toJson()).toList(),
    };
  }


}

class Participant {
  late int participantId;
  late Challenge challenge;

  Participant();

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant()
      ..participantId = json['participant_id']
      ..challenge = Challenge.fromJson(json['challenge']);
  }

  Map<String, dynamic> toJson() {
    return {
      'participant_id': participantId,
      'challenge': challenge.toJson(),
    };
  }
}