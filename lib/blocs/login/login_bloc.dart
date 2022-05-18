import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:behtarino/models/login_model.dart';
import 'package:behtarino/repositories/authentication/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository repository;

  LoginBloc({required this.repository}) : super(LoginInitial()) {
    on<SubmitLogin>((event, emit) => _submitLogin(event.userName, emit));
  }

  Future<void> _submitLogin(String userName, Emitter<LoginState> emit) async {

    emit(LoginLoading());

    try {
      final response = await repository.postUserName(userName);
      final body = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok && body['key'] != null) {
        emit(LoginDone(
          login: LoginModel(
            key: body['key'],
          ),
        ));
      }

      if(response.statusCode != HttpStatus.ok || body['key'] == null) {
        emit(LoginError(message: 'خطایی رخ داده لطفا دوباره امتحان کنید!'));
      }
    } catch(e) {
      emit(LoginError(message: 'خطایی رخ داده لطفا دوباره امتحان کنید!'));
    }

  }
}
