import '../entities/events.dart';

class EventsModel extends Events {
  const EventsModel({
    required String id,
    required String name,
    required String start,
    required String end,
  }) : super(
          id: id,
          name: name,
          start: start,
          end: end,
        );

  factory EventsModel.fromJson(Map<String, dynamic> raw) {
    return EventsModel(
      id: raw['id'] as String,
      name: raw['name'] as String,
      start: raw['start'] as String,
      end: raw['end'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start': start,
      'end': end,
    };
  }
}
