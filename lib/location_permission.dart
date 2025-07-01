/*
import 'package:ecommerce/cubit/location_cubit.dart';
import 'package:ecommerce/view/screens/home_screen.dart';
import 'package:ecommerce/view/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, locationState) {
        final Size screenSize = MediaQuery.of(context).size;
        final double screenWidth = screenSize.width;
        final double screenHeight = screenSize.height;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: Container(
            decoration: BoxDecoration(

            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenWidth * 0.09),

                  Text(
                    'Turn On Your Location',
                    style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF455A64)
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: Text(
                      'To Continues, Let Your Device Turn On Location, Which Uses Google’s Location Service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF455A64)
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: () async {
                      final locationCubit = context.read<LocationCubit>();
                      await locationCubit.getCurrentLocation();
                      final currentState = locationCubit.state;

                      if (currentState is LocationLoaded) {
                        // طباعة الإحداثيات للتأكد
                        print('الإحداثيات المرسلة:');
                        print('Lat: ${currentState.location.latitude}');
                        print('Lng: ${currentState.location.longitude}');

                        // الانتقال للصفحة الرئيسية مع إرسال الإحداثيات
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                            ),
                          ),
                        );
                      } else if (currentState is LocationError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('فشل في الحصول على الموقع. يرجى التأكد من تفعيل GPS'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.8, 48),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      width: screenWidth * 0.8,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF25AE4B), Color(0xFF0F481F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Yes, Turn It On',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                  ,SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: Size(screenWidth * 0.8, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.transparent,
                    ),
                    child: Text('Cancel',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF455A64))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}*/