import 'package:ecommerce/cubit/login_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/forget_password_screen.dart';
import 'package:ecommerce/view/screens/signup_screen.dart';
import 'package:ecommerce/view/widget/email_widget.dart';
import 'package:ecommerce/view/widget/password_widget.dart';
import 'package:ecommerce/view/widget/social_loginbutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool rememberMe = false;

  static const passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('savedEmail') ?? '';
        passwordController.text = prefs.getString('savedPassword') ?? '';
      }
    });
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('savedEmail', email);
      await prefs.setString('savedPassword', password);
    } else {
      await prefs.remove('savedEmail');
      await prefs.remove('savedPassword');
    }
    await prefs.setBool('rememberMe', rememberMe);
  }

  void _validateAndLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;

      if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(email)) {
        emailError = "Please enter a valid email address";
      }

      if (!RegExp(passwordRegex).hasMatch(password)) {
        passwordError =
        "Password must be at least 8 characters, include uppercase, lowercase, number, and symbol.";
      }
    });

    if (emailError == null && passwordError == null) {
      await _saveCredentials(email, password);
      context.read<LoginCubit>().login(email: email, password: password);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginFailure) {
                          setState(() {
                            emailError = null;
                            passwordError = null;

                            if (state.message.contains("email")) {
                              emailError = state.message;
                            } else if (state.message.contains("Password")) {
                              passwordError = state.message;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        } else if (state is LoginSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login successful")),
                          );
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login to your account",
                              style: TextStyle(
                                fontSize: responsiveHeight(context, 32),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff1A1A1A),
                              ),
                            ),
                            SizedBox(height: responsiveHeight(context, 8)),
                            const Text(
                              'It\'s great to see you again.',
                              style: TextStyle(color: Color(0xff808080)),
                            ),
                            SizedBox(height: responsiveHeight(context, 24)),

                            /// Email Input
                            EmailWidget(
                              emailEditingController: emailController,
                              errorText: emailError,
                            ),
                            SizedBox(height: responsiveHeight(context, 16)),

                            /// Password Input
                            PasswordWidget(
                              passwordEditingController: passwordController,
                              errorText: passwordError,
                            ),
                            SizedBox(height: responsiveHeight(context, 10)),

                            /// Remember Me Checkbox
                            Row(

                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() => rememberMe = value ?? false);
                                  },
                                  activeColor: const Color(0xFF4CAF50),
                                ),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontSize: responsiveWidth(context, 14),
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsiveHeight(context, 24)),

                            /// Forgot Password
                            Row(
                              children: [
                                Text(
                                  'Forget your password?',
                                  style: TextStyle(
                                    fontSize: responsiveWidth(context, 14),
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                           ForgetPasswordScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Reset your password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsiveWidth(context, 15),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsiveHeight(context, 24)),

                            /// Login Button
                            SizedBox(
                              width: double.infinity,
                              height: responsiveHeight(context, 54),
                              child: ElevatedButton(
                                onPressed: state is LoginLoading
                                    ? null
                                    : () => _validateAndLogin(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1A1A1A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child: state is LoginLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  'Login',
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

                            /// OR Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      fontSize: responsiveWidth(context, 12),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade400,
                                  ),
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

                /// Bottom Signup Prompt
                SafeArea(
                  child: Padding(
                    padding:
                    EdgeInsets.only(bottom: responsiveHeight(context, 10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account?",
                          style: TextStyle(
                            fontSize: responsiveWidth(context, 20),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupScreen()),
                            );
                          },
                          child: Text(
                            'Join',
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
    );
  }
}
