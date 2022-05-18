import '../entities/auth.dart';

class AuthModel extends Auth {
  const AuthModel({
    required String key,
    required String token,
    required String userName,
  }) : super(
    key: key,
    token: token,
    userName: userName,
  );


  factory AuthModel.fromJson(Map<String, dynamic> raw) {
    return AuthModel(
      key: raw['key'] as String,
      token: raw['token'] as String,
      userName: raw['userName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'token': token,
      'userName': userName,
    };
  }
}