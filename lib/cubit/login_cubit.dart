import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Main login method
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final validationMessage = _validateCredentials(email, password);

    if (validationMessage != null) {
      emit(LoginFailure(validationMessage));
      return;
    }

    emit(LoginLoading());

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_handleFirebaseError(e)));
    } catch (e) {
      emit(LoginFailure("Something went wrong: $e"));
    }
  }

  /// Validates the email and password inputs
  String? _validateCredentials(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return "Please enter email and password";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email";
    }

    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      return "Password must be at least 8 characters long, include uppercase, lowercase, number, and special character.";
    }

    return null;
  }

  /// Returns a user-friendly error message based on FirebaseAuthException
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
        return "Incorrect password.";
      case 'invalid-email':
        return "The email address is badly formatted.";
      default:
        return "Login failed. ${e.message}";
    }
  }
}
