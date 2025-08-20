import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child:Padding(
                padding: EdgeInsets.symmetric(
                  vertical: responsiveHeight(context, 16),
                  horizontal: responsiveWidth(context, 24),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackButton(),
                      Text(
                        "Help Center",
                        style: TextStyle(
                          fontSize: responsiveWidth(context, 24),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      NotificationIcon(),
                    ],
                  ),
                  SizedBox(height: responsiveHeight(context, 24)),
                  CustomContainerCenter(title: 'Custom Service',
                      icon: Icons.headset_mic_sharp,onTap: (){
                    
                    },),
                  CustomContainerCenter(title: 'Whatsapp',
                      icon: FontAwesomeIcons.whatsapp),
                  CustomContainerCenter(title: 'website',
                      icon: Icons.web),
                  CustomContainerCenter(title: 'Facebook',
                      icon: FontAwesomeIcons.facebook),
                  CustomContainerCenter(title: 'Twitter',
                      icon: FontAwesomeIcons.twitter),
                  CustomContainerCenter(title: 'Instagram',
                      icon: FontAwesomeIcons.instagram),
                ],
              ),
            ),
        ),
      ),

    );
  }
}




class CustomContainerCenter extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const CustomContainerCenter({
    super.key,
    required this.title,
    required this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveHeight(context, 64),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xffE6E6E6)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: responsiveWidth(context, 12)),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black87,
                size: responsiveWidth(context, 24),
              ),
               SizedBox(width: responsiveWidth(context, 12)),
              Expanded(
                child: Text(
                  title,
                  style:  TextStyle(
                    fontSize: responsiveWidth(context, 20),
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

