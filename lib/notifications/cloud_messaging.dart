import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CloudMessagingTools {
  static final CloudMessagingTools _instance = CloudMessagingTools._internal();
  CloudMessagingTools._internal();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Device token
  late String? token;

  factory CloudMessagingTools() {
    return _instance;
  }

  /// Define a top-level named handler which background/terminated messages will
  /// call.
  ///
  /// To verify things are working, check out the native platform logs.
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  Future<void> sendPushMessage() async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    // try {
    //   await http.post(
    //     Uri.parse('https://api.rnfirebase.io/messaging/send'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: constructFCMPayload(token),
    //   );
    //   print('FCM request for device sent!');
    // } catch (e) {
    //   print(e);
    // }
  }
}
