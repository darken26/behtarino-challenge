part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class SubmitEvent extends CalendarEvent {
  final String name;
  final String start;
  final String end;

  SubmitEvent({
    required this.name,
    required this.start,
    required this.end,
  });

  @override
  List<Object> get props => [
    name,
    start,
    end,
  ];
}
