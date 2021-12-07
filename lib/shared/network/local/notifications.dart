import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_app/modules/chat/chat.dart';
import 'package:social_app/shared/components/components.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class PushNotifications {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static const String _authServerKey =
      'AAAAoxOe8nM:APA91bGtk07aDPeK3PBE1oTfCQLR_DN88iyzfpU9JbUNM0SK2WxSL-gem0iiG2XpMnf6GuygzmZ02GSCUBPDvIswj-Ies5_8xd-MAgOsNr8zr4UUyBDR2HjYdGMrj696pJEyiHH44Grn'; // Paste your FCM auth Key here

  static Future initialize() async {
    if (Platform.isAndroid)
      _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    if (Platform.isIOS)
      _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showToast(message: 'New message from ${message.notification!.title}', state: toastStates.success);
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showToast(message: 'New message from ${message.notification!.title}', state: toastStates.success);
      if (message.data != null) {
       _serializeAndNavigate(message.data);
      }
    });

    _fcm.onTokenRefresh.listen((newToken) {
      if (FirebaseAuth.instance.currentUser != null) {
        final userID = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .update({'fcm': newToken});
      }
    });
  }
  static Future<void> _serializeAndNavigate(
      Map<String, dynamic> messageData) async {
    final chatID = messageData['text'];
    final contactID = messageData['senderId'];
    final navigatorKey =GlobalKey<NavigatorState>();
    DocumentSnapshot contactDetails = await FirebaseFirestore.instance
        .collection('users')
        .doc(contactID)
        .get();
    // navigatorKey.currentState!.pushNamed(ChatDetails.routeName,
    //     arguments: {'chatID': chatID, 'contactDetails': contactDetails});
  }


  static Future<void> sendNotification(
      {required String? title,
      required String? message,
      required String? notificationToken}) async {
    final postUrl = "https://fcm.googleapis.com/fcm/send";
    final data = {
      "notification": {"body": message, "title": title,"sound" : "default"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
      },
      "to": "$notificationToken"
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$_authServerKey'
    };
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );
    try {
      final response = await Dio(options).post(postUrl, data: data);

      if (response.statusCode == 200) {
        //Notification sent successfully
        print("done");
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }
  }

  static Future<String?> getNotificationsToken() async {
    return await _fcm.getToken();
  }
}
