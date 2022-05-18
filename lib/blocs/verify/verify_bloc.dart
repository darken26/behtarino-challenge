import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:behtarino/repositories/authentication/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/sqflite/auth_db.dart';
import '../../models/auth_model.dart';
import '../../models/verify_model.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {

  final AuthenticationRepository repository;
  VerifyBloc({required this.repository}) : super(VerifyInitial()) {
    on<SubmitOtp>(_submitOtp);
  }

  Future<void> _submitOtp(
    VerifyEvent event,
    Emitter<VerifyState> emit,
  ) async {

    if(event is SubmitOtp) {

      Map<String, dynamic> requestBody = {
        "username": event.userName,
        "key": event.key,
        "otp": event.otp,
      };

      emit(VerifyLoading());

      try {
        final response = await repository.postActivationCode(requestBody);
        final body = jsonDecode(response.body);

        if (response.statusCode == HttpStatus.ok && body['token'] != null) {

          await AuthenticationDBHelper.instance
              .add(AuthModel(
            key: event.key,
            token: body['token'],
            userName: event.userName,
          )).then((_) {
            emit(VerifyDone(
              verify: VerifyModel(
                token: body['token'],
              ),
            ));
          });

        }

        if(response.statusCode != HttpStatus.ok || body['token'] == null) {
          emit(VerifyError(message: 'خطایی رخ داده لطفا دوباره امتحان کنید!'));
        }
      } catch (e) {
        emit(VerifyError(message: 'خطایی رخ داده لطفا دوباره امتحان کنید!'));
      }
    }

  }
}
