import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        _buildSocialButton(
          context: context,
          icon: FontAwesomeIcons.google,
          text: "Login with Google",
          textColor: Colors.black,
          iconColor: Colors.red,
          fontSize: responsiveWidth(context, 18),
          iconSize: responsiveWidth(context, 20),
          backgroundColor: Colors.white, // Google button stays white

        ),
        const SizedBox(height: 12),
        _buildSocialButton(
          context: context,
          icon: FontAwesomeIcons.facebook,
          text: "Login wit Facebook",
          textColor: Colors.white,

          iconColor: Colors.white,
          fontSize: responsiveWidth(context, 18),
          iconSize: responsiveWidth(context, 20),
          backgroundColor: Color(0xff1877F2), // Google button stays white

        ),

      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color textColor,

    required Color iconColor,
    required double fontSize,
    required double iconSize,
    required Color backgroundColor,


  }) {
    return Container(
      width: double.infinity,
      height: responsiveHeight(context, 56),
      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:   const Color(0xffCCCCCC),
          width: 1.5,
        ),
        boxShadow:[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // <-- center the Row
          mainAxisSize: MainAxisSize.min, // <-- center children tightly
          children: [
            FaIcon(icon, color: iconColor, size: iconSize),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color:  textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}