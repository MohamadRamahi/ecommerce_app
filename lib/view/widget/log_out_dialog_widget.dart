import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';

class logout_dialog_widget extends StatelessWidget {
  const logout_dialog_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: Icon(
        Icons.error,
        color: Colors.red,
        size: responsiveWidth(context, 64),
      ),
      title: Text(
        'Logout?',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: TextStyle(color: Color(0xff808080)),
        textAlign: TextAlign.center,
      ),
      actions: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: responsiveHeight(context, 54),
              child: ElevatedButton(
                onPressed:
                    () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                ),
                child: Text(
                  'Yes, Logout',
                  style: TextStyle(color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: responsiveHeight(context, 12),),
            SizedBox(
              width: double.infinity,
              height: responsiveHeight(context, 54),
              child: ElevatedButton(
                onPressed:
                    () => Navigator.pop(context, false),
                style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    side: BorderSide(
                        color: Color(0xffCCCCCC)
                    )

                ),
                child: Text(
                  'No, Cancel',
                  style: TextStyle(color: Colors.black87,
                  ),
                ),
              ),
            ),

            /* TextButton(
               onPressed: () => Navigator.pop(context, true),
               child: const Text('Logout',
               style: TextStyle(
                 color: Colors.red
               ),
               ),
             ),*/
            /*TextButton(
              onPressed:
                  () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),*/
          ],
        ),
      ],
    );
  }
}
