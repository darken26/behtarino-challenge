import 'package:equatable/equatable.dart';

class Events extends Equatable {
  final String id;
  final String name;
  final String start;
  final String end;

  const Events({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
  });

  @override
  List<Object> get props => [
    id,
    name,
    start,
    end,
  ];

  @override
  bool get stringify => true;
}
