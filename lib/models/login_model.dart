import '../entities/login.dart';

class LoginModel extends Login {
  const LoginModel({
    required String key,
  }) : super(
    key: key,
  );


  factory LoginModel.fromJson(Map<String, dynamic> raw) {
    return LoginModel(key: raw['key'] as String);
  }
}