part of 'verify_bloc.dart';

abstract class VerifyState extends Equatable {
  const VerifyState();

  @override
  List<Object> get props => [];
}

class VerifyInitial extends VerifyState {}

class VerifyLoading extends VerifyState {}

class VerifyDone extends VerifyState {
  final VerifyModel verify;

  VerifyDone({required this.verify});

  @override
  List<Object> get props => [verify];
}

class VerifyError extends VerifyState {
  final String message;

  VerifyError({required this.message});

  @override
  List<Object> get props => [message];
}
