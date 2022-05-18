part of 'verify_bloc.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent();
}

class SubmitOtp extends VerifyEvent {
  final int otp;
  final String key;
  final String userName;

  SubmitOtp({
    required this.otp,
    required this.key,
    required this.userName,
  });

  @override
  List<Object> get props => [otp, key, userName];
}
