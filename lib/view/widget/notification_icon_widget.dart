import 'package:ecommerce/view/screens/notification_screen.dart';
import 'package:flutter/material.dart';

class NotificationIcon extends StatefulWidget {
  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  bool hasNotification = true;

  void showNotifications(BuildContext context) {
    setState(() {
      hasNotification = false;
    });
  Navigator.push(context,
  MaterialPageRoute(builder: (context)=>NotificationScreen()));

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => showNotifications(context),
        child: Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xffF5F5F5),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(Icons.notifications_none_outlined, color: Colors.black, size: 20),
              ),
              if (hasNotification)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
