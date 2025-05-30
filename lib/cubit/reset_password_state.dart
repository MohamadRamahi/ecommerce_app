// lib/cubit/reset_password_state.dart

part of 'reset_password_cubit.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  ResetPasswordError(this.message);
}
