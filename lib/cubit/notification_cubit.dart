import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_state.dart';

class NotificationItem {
  final String title;
  final String message;
  final String timestamp;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'timestamp': timestamp,
    'isRead': isRead,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'],
      message: json['message'],
      timestamp: json['timestamp'],
      isRead: json['isRead'],
    );
  }
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final List<NotificationItem> _notifications = [];
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _messageSubscription;

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  Future<void> initNotifications() async {
    emit(NotificationLoading());
    try {
      await loadFromStorage();
      await _messaging.requestPermission(alert: true, badge: true, sound: true);

      // اشترك بالـ onMessage
      await _messageSubscription?.cancel();
      _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
        addNotificationFromMessage(message); // ✅ استعمل الدالة الموحدة
      });

      // اعرض الرسائل الموجودة فقط بدون إعادة إضافتها
      emit(NotificationLoaded(List.from(_notifications)));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void markAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications[index].isRead = true;
      saveToStorage();
      emit(NotificationLoaded(List.from(_notifications)));
    }
  }

  Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
    _notifications.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList("notifications", jsonList);
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("notifications") ?? [];
    _notifications.clear();
    _notifications
        .addAll(jsonList.map((n) => NotificationItem.fromJson(jsonDecode(n))));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  void addNotificationFromMessage(RemoteMessage message, {bool isFromUserClick = false}) {
    if (message.notification != null) {
      final newItem = NotificationItem(
        title: message.notification!.title ?? "No title",
        message: message.notification!.body ?? "",
        timestamp: DateTime.now().toString(),
        isRead: isFromUserClick,
      );

      // ✅ تحقق إذا الإشعار موجود مسبقًا
      final alreadyExists = _notifications.any((n) =>
      n.title == newItem.title &&
          n.message == newItem.message
      );

      if (!alreadyExists) {
        _notifications.insert(0, newItem);
        saveToStorage();
        emit(NotificationLoaded(List.from(_notifications)));
      }
    }
  }




}
