part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class SubmitLogin extends LoginEvent {
  final String userName;

  SubmitLogin({required this.userName});

  @override
  List<Object> get props => [userName];
}
