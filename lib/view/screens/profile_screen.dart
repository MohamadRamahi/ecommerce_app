import 'package:ecommerce/responsive.dart';
import 'package:ecommerce/view/widget/notification_icon_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                  ),
                  Text(
                    "Account",
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
              
             Expanded(
                 child: Column(
                   children: [

                     ProfileMenuItem(
                       icon: Icons.shopping_bag_outlined,
                       title: 'My Orders',
                       onTap: () {
                         // Navigate to orders screen
                       },
                     ),
                     Divider(
                       thickness: 8,
                       color: Color(0xffE6E6E6),
                     ),
                     ProfileMenuItem(
                       icon: Icons.person_outline,
                       title: 'My Details',
                       onTap: () {
                         // Navigate to details screen
                       },
                     ),
                     Divider(
                       color: Color(0xffE6E6E6),
                     ),
                     ProfileMenuItem(
                       icon: Icons.home_outlined,
                       title: 'Address Book',
                       onTap: () {},
                     ),
                     Divider(
                       color: Color(0xffE6E6E6),
                     ),
                     ProfileMenuItem(
                       icon: Icons.credit_card_sharp,
                       title: 'Payment Method',
                       onTap: () {},
                     ),
                     Divider(
                       color: Color(0xffE6E6E6),
                     ),
                     ProfileMenuItem(
                       icon: Icons.notifications_none_outlined,
                       title: 'Notifications',
                       onTap: () {},
                     ),
                     Divider(
                       thickness: 8,
                       color: Color(0xffE6E6E6),
                     ),
                     ProfileMenuItem(
                       icon: Icons.question_mark_outlined,
                       title: 'FAQs',
                       onTap: () {},
                     ),
                     Divider(
                       color: Color(0xffE6E6E6),
                     ),
                     ProfileMenuItem(
                       icon: Icons.headset_mic_rounded,
                       title: 'Help Center',
                       onTap: () {},
                     ),
                     Divider(
                       thickness: 8,
                       color: Color(0xffE6E6E6),
                     ),
                     ProfileMenuItem(
                       icon: Icons.logout,
                       title: 'Log Out',
                       onTap: () async {
                         final shouldLogout = await showDialog<bool>(
                           context: context,
                           builder: (context) {
                             return AlertDialog(
                               backgroundColor:Colors.white ,
                               title: const Text('Confirm Logout'),
                               content: const Text('Are you sure you want to log out?'),
                               actions: [
                                 TextButton(
                                   onPressed: () => Navigator.pop(context, false),
                                   child: const Text('Logout',
                                   style: TextStyle(
                                     color: Colors.red
                                   ),
                                   ),
                                 ),
                                 TextButton(
                                   onPressed: () => Navigator.pop(context, true),
                                   child: const Text(
                                     'Cancel',
                                     style: TextStyle(color: Colors.black),
                                   ),
                                 ),
                               ],
                             );
                           },
                         );

                         if (shouldLogout == true) {
                           await FirebaseAuth.instance.signOut();
                           Navigator.of(context, rootNavigator: true)
                               .pushNamedAndRemoveUntil('/login', (route) => false);
                         }
                       },

                       textColor: Colors.red,
                       showArrow: false,
                     ),




                   ],
                 )
             )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final bool showArrow;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.showArrow = true, // default true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey[200],
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: textColor ?? Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black,
                ),
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

