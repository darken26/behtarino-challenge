import '../entities/verify.dart';

class VerifyModel extends Verify {
  const VerifyModel({
    required String token,
  }) : super(
    token: token,
  );


  factory VerifyModel.fromJson(Map<String, dynamic> raw) {
    return VerifyModel(token: raw['token'] as String);
  }
}