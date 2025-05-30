import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  void verifyOtp(String enteredOtp) {
    emit(OtpLoading());

    // Simulate OTP validation
    Future.delayed(Duration(seconds: 2), () {
      if (enteredOtp == "1234") {
        emit(OtpSuccess());
      } else {
        emit(OtpFailure("Invalid OTP code"));
      }
    });
  }
}
