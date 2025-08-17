import 'package:ecommerce/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/view/screens/notification_screen.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();

}

class _NotificationIconState extends State<NotificationIcon> {
  void _openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>  NotificationScreen()),
    );
  }
  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationCubit>();
    for (int i = 0; i < cubit.notifications.length; i++) {
      cubit.markAsRead(i);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        bool hasUnread = false;

        if (state is NotificationLoaded) {
          hasUnread = state.notifications.any((n) => !n.isRead);
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => _openNotifications(context),
            child: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xffF5F5F5),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(Icons.notifications_none_outlined,
                        color: Colors.black, size: 20),
                  ),
                  if (hasUnread)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
