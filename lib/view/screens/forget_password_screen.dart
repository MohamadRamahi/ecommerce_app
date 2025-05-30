import 'package:ecommerce/cubit/forget_password_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/otp_code_screen.dart';
import 'package:ecommerce/view/widget/email_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveWidth(context, 24),
              vertical: responsiveHeight(context, 16),
            ),
            child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
              listener: (context, state) {
                if (state is ForgetPasswordSuccess) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>OtpCodeScreen()));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is ForgetPasswordError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, size: responsiveWidth(context, 24)),
                          ),
                          Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: responsiveWidth(context, 32),
                              color: const Color(0xff1A1A1A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: responsiveHeight(context, 7)),
                          Text(
                            'Enter your email for the verification process.\nWe will send a 4-digit code to your email.',
                            style: TextStyle(
                              color: const Color(0xff808080),
                              fontSize: responsiveWidth(context, 16),
                            ),
                          ),
                          SizedBox(height: responsiveHeight(context, 24)),
                          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                            builder: (context, state) {
                              String? errorText;
                              if (state is ForgetPasswordError) {
                                errorText = state.message;
                              }
                              return EmailWidget(
                                emailEditingController: emailController,
                                errorText: errorText,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: responsiveHeight(context, 10)),
                    child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: responsiveHeight(context, 54),
                          child: ElevatedButton(
                            onPressed: state is ForgetPasswordLoading
                                ? null
                                : () {

                              context.read<ForgetPasswordCubit>().sendResetCode(
                                emailController.text.trim(),
                                
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1A1A1A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            child: state is ForgetPasswordLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                              'Send Code',
                              style: TextStyle(
                                fontSize: responsiveHeight(context, 22),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
