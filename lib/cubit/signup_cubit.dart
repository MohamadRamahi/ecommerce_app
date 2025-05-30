import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$');


    if (!emailRegex.hasMatch(email)) {
      emit(SignupFailure("Enter a valid email"));
      return;
    }
    if (!passwordRegex.hasMatch(password)) {
      emit(SignupFailure("Password must be at least 8 characters long, include uppercase, lowercase, number, and special character."));
      return;
    }

    emit(SignupLoading());

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(SignupFailure("Email already in use"));
      } else if (e.code == 'weak-password') {
        emit(SignupFailure("Password is too weak"));
      } else {
        emit(SignupFailure("Signup failed: ${e.message}"));
      }
    } catch (e) {
      emit(SignupFailure("Something went wrong: $e"));
    }
  }
}
