import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationSettingCubit extends Cubit<List<Map<String, dynamic>>> {
  NotificationSettingCubit()
      : super([
    {"title": "General Notifications", "value": true},
    {"title": "Sound", "value": true},
    {"title": "Vibrate", "value": false},
    {"title": "Special Offers", "value": true},
    {"title": "Promo & Discounts", "value": false},
    {"title": "Payments", "value": false},
    {"title": "Cashback", "value": true},
    {"title": "App Updates", "value": false},
    {"title": "New Service Available", "value": true},
    {"title": "New Tips Available", "value": false},

  ]);

  void toggleSettingNotification(int index, bool newValue) {
    final updatedList = List<Map<String, dynamic>>.from(state);
    updatedList[index]["value"] = newValue;
    emit(updatedList);
  }
}
