import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

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
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final List<NotificationItem> _notifications = [];
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  Future<void> initNotifications() async {
    emit(NotificationLoading());

    try {
      // طلب الإذن
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // الإستماع للإشعارات في المقدمة
      FirebaseMessaging.onMessage.listen((message) {
        if (message.notification != null) {
          _notifications.insert(
            0,
            NotificationItem(
              title: message.notification!.title ?? "No title",
              message: message.notification!.body ?? "",
              timestamp: DateTime.now().toString(),
              isRead: false,
            ),
          );
          emit(NotificationLoaded(List.from(_notifications)));
        }
      });

      emit(NotificationLoaded(List.from(_notifications)));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void markAsRead(int index) {
    _notifications[index].isRead = true;
    emit(NotificationLoaded(List.from(_notifications)));
  }
}
