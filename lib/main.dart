import 'package:firebase_chat_app/tools/chat_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/index.dart';
import 'notifications/cloud_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FireBase
  await Firebase.initializeApp();

  // Get the prefs
  ChatApp.prefs = await SharedPreferences.getInstance();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(
      CloudMessagingTools().firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    CloudMessagingTools().channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    CloudMessagingTools().flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await CloudMessagingTools()
        .flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(CloudMessagingTools().channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(ConfigPage());
}
