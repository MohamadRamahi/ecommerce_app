import 'package:ecommerce/const.dart';
import 'package:ecommerce/cubit/onbording_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Define yourself in your unique way',
     'image': 'assets/images/model_person2.png',
    },
    {
      'title': 'Enable your location',
      'description': 'We need your location to show nearby stores',
      //'image': 'assets/image/location.png', // replace with your location image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
              Positioned.fill(
               child: Image.asset(
               onboardingData[0]['image']!,
               fit: BoxFit.cover,
               ),
              ),
            Positioned.fill(
              child: Container(
                  color: Color(0xffE6E6E6)
              ),
            ),


            Container(
              color: Colors.white,
              child: SafeArea(
                child: BlocBuilder<OnboardingCubit, int>(
                  builder: (context, pageIndex) {
                    return Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: onboardingData.length,
                            onPageChanged: (index) {
                              context.read<OnboardingCubit>().changePage(index);
                            },
                            itemBuilder: (context, index) {
                              final item = onboardingData[index];
                              return Column(
                                children: [
                                  // صورة الشخص (أو صورة الموقع للصفحة الثانية)
                                  Expanded(
                                    child: Image.asset(
                                      item['image'] ?? 'assets/images/model_person2.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: responsiveHeight(context, 20)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: responsiveWidth(context, 30),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          item['title']!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: responsiveWidth(context, 24),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: responsiveHeight(context, 10)),

                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        /// زر "Get Started" أو "Enable Location"
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveWidth(context, 30),
                            vertical: responsiveHeight(context, 20),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: responsiveHeight(context, 56),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (pageIndex < onboardingData.length - 1) {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => _buildLocationPermissionPage(context),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: KbuttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    pageIndex == onboardingData.length - 1
                                        ? 'Enable Location'
                                        : 'Get Started',
                                    style: TextStyle(
                                      fontSize: responsiveWidth(context, 18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: responsiveWidth(context, 10)),
                                  Icon(Icons.arrow_forward, color: Colors.white),
                                ],
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
    );
  }
}

Widget _buildLocationPermissionPage(BuildContext context) {
  return Scaffold(

    body: Stack(

      children: [


        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Enable Location',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Color(0xFF455A64)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 335,
                child: Text(
                  'To provide better service, we need access to your location. Please enable location services.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF455A64)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () async {
                  await _enableLocation();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:KbuttonColor,
                  foregroundColor: Colors.white,
                  minimumSize: Size(307, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Enable Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              SizedBox(height: 20),

              // زر إلغاء (Cancel)
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: Size(307, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

}

Future<void> _enableLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("تم تحديد الموقع: ${position.latitude}, ${position.longitude}");
  } else {
    print("تم رفض الإذن!");
  }
}


