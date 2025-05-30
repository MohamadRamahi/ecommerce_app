part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpFailure extends OtpState {
  final String errorMessage;

  OtpFailure(this.errorMessage);
}
