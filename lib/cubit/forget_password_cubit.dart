// forget_password_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  void sendResetCode(String email) {
    if (!_isValidEmail(email)) {
      emit(ForgetPasswordError("Please enter a valid email address."));
    } else {
      emit(ForgetPasswordLoading());
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        emit(ForgetPasswordSuccess("A reset code has been sent to $email."));
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }
}
