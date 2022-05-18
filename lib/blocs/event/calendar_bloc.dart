import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/sqflite/auth_db.dart';
import '../../core/sqflite/events_db.dart';
import '../../models/events_model.dart';
import '../../repositories/events/events_repository.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final EventsRepository repository;

  CalendarBloc({required this.repository}) : super(CalendarInitial()) {
    on<SubmitEvent>(_postEvent);
  }

  Future<void> _postEvent(
    CalendarEvent event,
    Emitter<CalendarState> emit,
  ) async {
    if (event is SubmitEvent) {
      emit(CalendarLoading());

      try {
        final requestBody = {
          "name": event.name,
          "start": event.start,
          "end": event.end,
        };

        await AuthenticationDBHelper.instance.getAuth().then((value) async {
          final response = await repository.postEvents(
            requestBody,
            value.first.token,
          );
          final body = jsonDecode(response.body);

          if (response.statusCode == HttpStatus.ok && body['id'] != null) {

            await EventsDBHelper.instance.add(EventsModel(
              id: body['id'],
              name: body['name'] ?? event.name,
              start: body['start'] ?? event.start,
              end: body['end'] ?? event.end,
            )).whenComplete(() async {
              emit(CalendarDone(
                events: EventsModel(
                  id: body['id'],
                  name: body['name'],
                  start: body['start'],
                  end: body['end'],
                ),
              ));
            });

          }

          if (response.statusCode != HttpStatus.ok || body['id'] == null) {
            emit(
                CalendarError(message: 'خطایی رخ داده لطفا دوباره امتحان کنید!'));
          }
        });

      } catch (e) {
        emit(CalendarError(message: 'خطایی رخ داده لطفا دوباره امتحان کنید!'));
      }
    }
  }
}
