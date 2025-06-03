import 'package:ecommerce/cubit/location_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/screens/set_location_screen.dart';
import 'package:ecommerce/view/widget/location_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widget/notification_icon_widget.dart';

// Create an enum for payment methods
enum PaymentMethod { card, cash, pay }

class CheckoutScreen extends StatefulWidget {
  final LatLng? userLocation;

  const CheckoutScreen({super.key, this.userLocation});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddressTitle = "No location selected";
  PaymentMethod selectedMethod = PaymentMethod.card;

  @override
  void initState() {
    super.initState();
    _convertCoordinatesToAddress(widget.userLocation);
  }

  Future<void> _convertCoordinatesToAddress(LatLng? location) async {
    if (location != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          setState(() {
            selectedAddressTitle =
            "${placemark.street}, ${placemark.locality}, ${placemark.country}";
          });
        }
      } catch (e) {
        print("Error getting address: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsiveHeight(context, 16),
            horizontal: responsiveWidth(context, 24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: responsiveWidth(context, 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                   NotificationIcon(),
                ],
              ),

              SizedBox(height: responsiveHeight(context, 16)),

              // Address section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: responsiveWidth(context, 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: ()  {},
                    child: const Text(
                      'Change',
                      style: TextStyle(color: Colors.black),
                    ),
                  )



                ],
              ),
              SizedBox(height: responsiveHeight(context, 16)),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.grey),
                  SizedBox(width: responsiveWidth(context, 10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocationTitleWidget(),
                      SizedBox(height: responsiveHeight(context, 20)),
                    ],
                  ),
                ],
              ),

              const Divider(color: Color(0xffE6E6E6)),

              SizedBox(height: responsiveHeight(context, 20)),
               Text(
                'Payment with',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: responsiveWidth(context, 16),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: responsiveHeight(context, 16)),

              // Payment buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectablePaymentButton(
                    isSelected: selectedMethod == PaymentMethod.card,
                    onTap: () {
                      setState(() {
                        selectedMethod = PaymentMethod.card;
                      });
                    },
                    text: "Card",
                    icon: Icons.credit_card,
                  ),
                  SelectablePaymentButton(
                    isSelected: selectedMethod == PaymentMethod.cash,
                    onTap: () {
                      setState(() {
                        selectedMethod = PaymentMethod.cash;
                      });
                    },
                    text: "Cash",
                    icon: Icons.money,
                  ),
                  SelectablePaymentButton(
                    isSelected: selectedMethod == PaymentMethod.pay,
                    onTap: () {
                      setState(() {
                        selectedMethod = PaymentMethod.pay;
                      });
                    },
                    text: "Pay",
                    icon: Icons.apple,
                  ),

                ],
              ),
              SizedBox(height: responsiveHeight(context, 16),),
              SizedBox(
                height: 52,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xffE6E6E6),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                      prefixIcon:Padding(
                          padding:EdgeInsets.symmetric(
                            horizontal: responsiveWidth(context, 12),
                            vertical: responsiveHeight(context, 12),
                          ),
                        child: Image.asset('assets/images/visa2.png'),
                      ) ,
                    hintText:'**** **** **** 1234',
                    suffixIcon: Icon(Icons.edit)
                  ),
                ),
              ),
              SizedBox(height: responsiveHeight(context, 20),),
              const Divider(color: Color(0xffE6E6E6)),
              SizedBox(height: responsiveHeight(context, 20),),
              Text('Order Summary',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

/*class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final List<Color> gradientColors;
  final TextStyle? textStyle;
  final Icon icon;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 48,
    this.borderRadius = 25,
    this.gradientColors = const [Color(0xFF25AE4B), Color(0xFF0F481F)],
    this.textStyle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}


*/
class SelectablePaymentButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  const SelectablePaymentButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = responsiveHeight(context, 40);
    final double buttonWidth = responsiveWidth(context, 120);

    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 16,
            ),
            SizedBox(width: responsiveWidth(context, 4)),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
