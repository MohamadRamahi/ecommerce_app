import 'package:ecommerce/cubit/otp_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'reset_password_screen.dart'; // screen to navigate to

class OtpCodeScreen extends StatelessWidget {
  const OtpCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String enteredOtp = '';

    return BlocProvider(
      create: (_) => OtpCubit(),
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
                    child: BlocConsumer<OtpCubit, OtpState>(
                      listener: (context, state) {
                        if (state is OtpSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResetPasswordScreen(),
                            ),
                          );
                        } else if (state is OtpFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage),
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
                              icon: Icon(
                                Icons.arrow_back,
                                size: responsiveWidth(context, 24),
                              ),
                            ),
                            Text(
                              'Enter 4 Digit Code',
                              style: TextStyle(
                                fontSize: responsiveWidth(context, 32),
                                color: const Color(0xff1A1A1A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: responsiveHeight(context, 8)),
                            Text(
                              'Enter the 4-digit code that you received on your email.',
                              style: TextStyle(
                                color: const Color(0xff808080),
                                fontSize: responsiveWidth(context, 16),
                              ),
                            ),
                            SizedBox(height: responsiveHeight(context, 24)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsiveWidth(context, 24),
                              ),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
                                keyboardType: TextInputType.number,
                                autoDismissKeyboard: true,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10),
                                  fieldWidth: responsiveWidth(context, 64),
                                  fieldHeight: responsiveHeight(context, 60),
                                  activeFillColor: Colors.white,
                                  selectedFillColor: Colors.white,
                                  inactiveFillColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  borderWidth: 2,
                                  activeColor: Colors.grey,
                                  selectedColor: Colors.black,
                                ),
                                enableActiveFill: true,
                                onChanged: (_) {},
                                onCompleted: (value) {
                                  enteredOtp = value;
                                },


                              ),
                            ),
                            SizedBox(height: responsiveHeight(context, 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Email not received?',style:
                                  TextStyle(fontSize: responsiveWidth(context, 18),
                                    color: Color(0xff808080),
                                  ),
                                ),
                                Text('Resend Code',style:
                                  TextStyle(
                                      color: Color(0xff1A1A1A),
                                    fontSize: responsiveWidth(context, 18)
                                  ),

                                ),
                              ],
                            ),
                            SizedBox(height: responsiveHeight(context, 24),),
                            SizedBox(
                              width: double.infinity,
                              height: responsiveHeight(context, 54),
                              child: ElevatedButton(
                                onPressed: state is OtpLoading
                                    ? null
                                    : () {
                                  print("DEBUG OTP length: ${enteredOtp.length}, value: '$enteredOtp'");
                                  if (enteredOtp.length == 4) {
                                    context.read<OtpCubit>().verifyOtp(enteredOtp);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please enter all 4 digits."),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1A1A1A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child: state is OtpLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                  "Verify OTP",
                                  style: TextStyle(
                                    fontSize: responsiveHeight(context, 20),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
