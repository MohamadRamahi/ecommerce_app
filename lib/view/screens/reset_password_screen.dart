import 'package:ecommerce/view/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/conferm_password_widget.dart';
import 'package:ecommerce/view/widget/new_password_widget.dart';
import '../../cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

  @override
  void dispose() {
    newPasswordEditingController.dispose();
    confirmPasswordEditingController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _showSuccessDialog(context); // Show dialog immediately (bypassing Cubit)
    }
  }


  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsiveWidth(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: responsiveWidth(context, 80)),
              SizedBox(height: responsiveHeight(context, 16)),
              Text(
                "Password Changed!",
                style: TextStyle(
                  fontSize: responsiveWidth(context, 22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsiveHeight(context, 10)),
              Text(
                "You can now use your new password to login to your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsiveWidth(context, 16),
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: responsiveHeight(context, 24)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                   // Navigator.of(context).pop(); // Close dialog
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: responsiveHeight(context, 14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveWidth(context, 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveWidth(context, 24),
              vertical: responsiveHeight(context, 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                        listener: (context, state) {
                          if (state is ResetPasswordSuccess) {
                            _showSuccessDialog(context);
                          } else if (state is ResetPasswordError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.arrow_back, size: responsiveWidth(context, 24)),
                              ),
                              Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: responsiveWidth(context, 32),
                                  color: const Color(0xff1A1A1A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: responsiveHeight(context, 7)),
                              Text(
                                'Set the new password for your account so you\ncan log in and access all the features.',
                                style: TextStyle(
                                  color: const Color(0xff808080),
                                  fontSize: responsiveWidth(context, 16),
                                ),
                              ),
                              SizedBox(height: responsiveHeight(context, 24)),
                              NewPasswordWidget(
                                newPasswordEditingController: newPasswordEditingController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a password";
                                  } else if (!passwordRegex.hasMatch(value)) {
                                    return "Password must be at least 8 characters,\ninclude upper/lowercase, number, and symbol";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: responsiveHeight(context, 16)),
                              ConfermPasswordWidget(
                                confirempasswordEditingController: confirmPasswordEditingController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password";
                                  } else if (value != newPasswordEditingController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: responsiveHeight(context, 24)),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: responsiveHeight(context, 54),
                  child: ElevatedButton(
                    onPressed: () => _submit(context),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: responsiveHeight(context, 20),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
