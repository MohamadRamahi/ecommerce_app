import 'package:ecommerce/cubit/signup_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/email_widget.dart';
import 'package:ecommerce/view/widget/name_widget.dart';
import 'package:ecommerce/view/widget/password_widget.dart';
import 'package:ecommerce/view/widget/social_loginbutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String?nameError;
  String? emailError;
  String? passwordError;

  static const passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateAndSignup(BuildContext context) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      nameError =null;
      emailError = null;
      passwordError = null;

      if(!RegExp(r'[a-zA-Z]').hasMatch(name)){
        nameError ="Please enter a valid name address";
      }
      if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(email)) {
        emailError = "Please enter a valid email address";
      }

      if (!RegExp(passwordRegex).hasMatch(password)) {
        passwordError =
        "Password must be at least 8 characters, include uppercase, lowercase, number, and symbol.";
      }
    });

    if (emailError == null && passwordError == null) {
      context
          .read<SignupCubit>()
          .signup(name: name, email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsiveWidth(context, 24),
                        vertical: responsiveHeight(context, 16),
                      ),
                      child: BlocConsumer<SignupCubit, SignupState>(
                        listener: (context, state) {
                          if (state is SignupFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.errorMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (state is SignupSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Signup successful"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create an account",
                                style: TextStyle(
                                  fontSize: responsiveHeight(context, 32),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff1A1A1A),
                                ),
                              ),
                              SizedBox(height: responsiveHeight(context, 8)),
                              const Text(
                                'Let\'s get you set up!',
                                style: TextStyle(color: Color(0xff808080)),
                              ),
                              SizedBox(height: responsiveHeight(context, 24)),


                              NameWidget(
                                nameEditingController: nameController,
                                errorText: nameError,
                              ),
                              SizedBox(height: responsiveHeight(context, 16)),


                              EmailWidget(
                                emailEditingController: emailController,
                                errorText: emailError,
                              ),
                              SizedBox(height: responsiveHeight(context, 16)),


                              PasswordWidget(
                                passwordEditingController: passwordController,
                                errorText: passwordError,
                              ),
                              SizedBox(height: responsiveHeight(context, 24)),


                              SizedBox(
                                width: double.infinity,
                                height: responsiveHeight(context, 54),
                                child: ElevatedButton(
                                  onPressed: state is SignupLoading
                                      ? null
                                      : () => _validateAndSignup(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1A1A1A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: state is SignupLoading
                                      ? const CircularProgressIndicator(
                                      color: Colors.white)
                                      : Text(
                                    'Create an account',
                                    style: TextStyle(
                                      fontSize:
                                      responsiveHeight(context, 22),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: responsiveHeight(context, 24)),


                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade400),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                        responsiveWidth(context, 12)),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(
                                        fontSize:
                                        responsiveWidth(context, 12),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                              SizedBox(height: responsiveHeight(context, 24)),

                              /// Social Buttons
                              SocialLoginButtons(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: responsiveHeight(context, 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                                fontSize: responsiveWidth(context, 20)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: responsiveWidth(context, 20),
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
