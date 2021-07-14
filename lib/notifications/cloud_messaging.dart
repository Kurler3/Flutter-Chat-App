import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsTools {
  static final PushNotificationsTools _instance =
      PushNotificationsTools._internal();

  PushNotificationsTools._internal();

  late FirebaseMessaging messaging;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  factory PushNotificationsTools() {
    _instance.messaging = FirebaseMessaging.instance;
    _instance.channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    _instance.flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    return _instance;
  }
}
