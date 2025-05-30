import 'package:ecommerce/const.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();

    // Delay navigation safely after first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds:3), () {
        Navigator.pushReplacementNamed(context, '/intro');
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              kLogoPath, // or 'assets/logo.png'
              width: responsiveWidth(context, 140),
              height: responsiveWidth(context, 140),
             // color: Colors.white,
            ),
            SizedBox(width: responsiveWidth(context, 12)),

          ],
        ),
      ),
    );
  }
}
