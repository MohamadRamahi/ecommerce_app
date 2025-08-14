import 'package:ecommerce/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // طلب الإذن (مهم لأندرويد 13 وفوق و iOS)
    await _firebaseMessaging.requestPermission();

    // جلب الـ Token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // استقبال الرسائل
    _handleForegroundMessages();
    _handleBackgroundNotification();

    // تسجيل المعالج للخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 رسالة جديدة في foreground: ${message.notification?.title}');
      // هنا تقدر تعرض Dialog أو Snackbar
    });
  }

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState!.pushNamed(
      '/notification',
      arguments: message,
    );
  }

  void _handleBackgroundNotification() {
    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
}

// معالج الخلفية لازم يكون top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 رسالة في background: ${message.notification?.title}');
}
