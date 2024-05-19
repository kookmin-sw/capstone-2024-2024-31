class SmsResult {
  final bool isSuccess;
  final String message;

  SmsResult({required this.isSuccess, required this.message});

  factory SmsResult.fromJson(Map<String, dynamic> json) {
    return SmsResult(
      isSuccess: json['isSuccess'],
      message: json['message'],
    );
  }
}
