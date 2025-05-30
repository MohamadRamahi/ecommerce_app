import 'package:ecommerce/cubit/category_navigation_cubit.dart';
import 'package:ecommerce/cubit/forget_password_cubit.dart';
import 'package:ecommerce/cubit/home_cubit.dart';
import 'package:ecommerce/cubit/location_cubit.dart';
import 'package:ecommerce/cubit/login_cubit.dart';
import 'package:ecommerce/cubit/onbording_cubit.dart';
import 'package:ecommerce/cubit/otp_cubit.dart';
import 'package:ecommerce/cubit/product_cubit.dart';
import 'package:ecommerce/cubit/reset_password_cubit.dart';
import 'package:ecommerce/cubit/search_cubit.dart';
import 'package:ecommerce/cubit/signup_cubit.dart';
import 'package:ecommerce/location_permission.dart';
import 'package:ecommerce/main_screen.dart';
import 'package:ecommerce/model/all_product.dart';
import 'package:ecommerce/model/location_repository.dart';
import 'package:ecommerce/view/screens/login_screen.dart';
import 'package:ecommerce/view/screens/onbording_screen.dart';
import 'package:ecommerce/view/screens/signup_screen.dart';
import 'package:ecommerce/view/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => OnboardingCubit()),
          BlocProvider(create: (context) => LocationCubit(LocationRepository())),
          BlocProvider(create: (context)=>LoginCubit()),
          BlocProvider(create: (context)=>SignupCubit()),
          BlocProvider(create: (context)=>ForgetPasswordCubit()),
          BlocProvider(create: (context)=>OtpCubit()),
          BlocProvider(create: (context)=>ResetPasswordCubit()),
          BlocProvider(create: (context) => ProductCubit()),
          BlocProvider(create: (context)=>CategoryCubit())

        ],
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          // home: LaunchDecider(), // 👈 This is important
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/intro': (context) => OnboardingScreen(),
            '/location': (context) => LocationScreen(),
            '/signup': (context) => SignupScreen(),
            '/login': (context) => LoginScreen(),
            '/home': (context) => MainScreen(),
            // '/favorites': (context) => FavoritesScreen(), // ✅ أضف هذا السطر


          },
          //home: NavigationbarWidget(),
        ),
    );




  }
}


