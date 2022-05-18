import 'package:equatable/equatable.dart';

class Verify extends Equatable {
  final String token;
  const Verify({required this.token});

  @override
  List<Object> get props => [token];

  @override
  bool get stringify => true;
}