part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarDone extends CalendarState {
  final EventsModel events;

  CalendarDone({required this.events});

  @override
  List<Object> get props => [events];
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError({required this.message});

  @override
  List<Object> get props => [message];
}
