import 'package:ecommerce/cubit/notification_setting_cubit.dart';
import 'package:ecommerce/view/widget/custom_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/cubit/notification_cubit.dart';

class ProfileNotificationScreen extends StatelessWidget {
  const ProfileNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    BackButton(),
                    Text(
                      "Notifications",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.notifications_none, size: 26),
                  ],
                ),
                const SizedBox(height: 20),

                /// Dynamic List
                Expanded(
                  child: BlocBuilder<NotificationSettingCubit, List<Map<String, dynamic>>>(
                    builder: (context, notificationSettings) {
                      return ListView.separated(
                        itemCount: notificationSettings.length,
                        separatorBuilder: (_, __) => Divider(
                          color: Colors.grey.shade300,
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final item = notificationSettings[index];
                          return ListTile(
                            title: Text(
                              item["title"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: CustomToggleSwitch(
                              value: item["value"],
                              onChanged: (value) {
                                context
                                    .read<NotificationSettingCubit>()
                                    .toggleSettingNotification(index, value);
                              },
                            ),

                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
