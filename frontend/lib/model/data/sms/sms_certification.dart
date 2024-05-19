class SmsCertification {
  final String phone;
  String certificationNumber;

  SmsCertification({required this.phone, this.certificationNumber = ''});

  factory SmsCertification.fromJson(Map<String, dynamic> json) {
    return SmsCertification(
      phone: json['phone'],
      certificationNumber: json['certificationNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'certificationNumber': certificationNumber,
    };
  }
}
