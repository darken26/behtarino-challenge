import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String key;
  final String token;
  final String userName;

  const Auth({required this.key, required this.token, required this.userName});

  @override
  List<Object> get props => [
    key,
    token,
    userName,
  ];

  @override
  bool get stringify => true;
}
