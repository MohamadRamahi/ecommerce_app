import 'package:ecommerce/cubit/notification_cubit.dart';
import 'package:ecommerce/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit()..initNotifications(),
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            final unread = notifications.where((n) => !n.isRead).toList();
            final read = notifications.where((n) => n.isRead).toList();

            return Scaffold(
              backgroundColor: Colors.white,
              body: DefaultTabController(
                length: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            const BackButton(),
                            const Center(
                              child: Text(
                                "Notifications",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TabBar(
                        indicatorColor: Color(0xFF25AE4B),
                        dividerColor: Colors.transparent,
                        labelColor: Color(0xFF25AE4B),
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(fontSize: 18),
                        tabs: [
                          Tab(text: 'All'),
                          Tab(text: 'Unread'),
                          Tab(text: 'Read'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildNotificationList(context, notifications,showEmptyMessage: true),
                            _buildNotificationList(context, unread, showEmptyMessage: true),
                            _buildNotificationList(context, read,showEmptyMessage: true),
                          ],
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is NotificationError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, List<NotificationItem> items, {bool showEmptyMessage = false}) {
    if (items.isEmpty && showEmptyMessage) {
      return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications,color: Color(0xffB3B3B3),
              size: responsiveWidth(context, 64),),
            SizedBox(height: responsiveHeight(context, 24),),
            Text(
              "You haven’t gotten any\n notifications yet!",
              textAlign: TextAlign.center, // نص مركزي

              style: TextStyle(fontSize: responsiveWidth(context, 20),
                  color: Color(0xff1A1A1A),
              fontWeight: FontWeight.w700),
            ),
            SizedBox(height: responsiveHeight(context, 12),),

            Text('We’ll alert you when something\n cool happens.',
                textAlign: TextAlign.center, // نص مركزي
                style: TextStyle(color: Color(0xff808080),
            fontSize: responsiveWidth(context, 18)))
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final notification = items[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: !notification.isRead
              ? () => context.read<NotificationCubit>().markAsRead(index)
              : null,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!notification.isRead) ...[
                    const Icon(Icons.circle, color: Color(0xFF25AE4B), size: 12),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: notification.isRead ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.message,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                notification.timestamp,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }
}
