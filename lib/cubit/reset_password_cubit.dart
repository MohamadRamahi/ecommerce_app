// lib/cubit/reset_password_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  void resetPassword({required String password, required String confirmPassword}) {
    if (password != confirmPassword) {
      emit(ResetPasswordError("Passwords do not match"));
    } else {
      // Simulate success
      emit(ResetPasswordSuccess());
    }
  }
}
