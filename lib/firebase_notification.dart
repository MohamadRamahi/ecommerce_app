import 'package:ecommerce/cubit/notification_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // مهم لإعدادات Firebase
import '../main.dart';

class FirebaseNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification(NotificationCubit cubit) async {
    // طلب الإذن
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // الحصول على الـ token
    String? token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _processMessage(cubit, message);
    });

    // Background → user clicked notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _processMessage(cubit, message, isFromUserClick: true);
      _handleMessage(message);
    });

    // Terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _processMessage(cubit, message, isFromUserClick: true);
        _handleMessage(message);
      }
    });

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _processMessage(NotificationCubit cubit, RemoteMessage message,
      {bool isFromUserClick = false}) {
    print("📩 Message received:");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Data: ${message.data}");

    cubit.addNotificationFromMessage(message, isFromUserClick: isFromUserClick);
  }

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed('/notification', arguments: message);
  }
}

// 🔹 Top-level background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("📩 Background message: ${message.notification?.title}");
}
