import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final String key;
  const Login({required this.key});

  @override
  List<Object> get props => [key];

  @override
  bool get stringify => true;
}