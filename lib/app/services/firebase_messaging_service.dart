import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../common/ui.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FireBaseMessagingService extends GetxService {
  String _token;
  Future<FireBaseMessagingService> init() async {
    firebaseCloudMessagingListeners();
    return this;
  }

  void firebaseCloudMessagingListeners() {
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Get.isRegistered<RootController>()) {
        Get.find<RootController>().getNotificationsCount();
      }
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        _newMessageNotification(message);
      } else {
        _defaultNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        if (Get.isRegistered<RootController>()) {
          Get.find<RootController>().changePage(2);
        }
      } else {
        if (Get.isRegistered<RootController>()) {
          Get.find<RootController>().changePage(1);
        }
      }
    });
    try {

       FirebaseMessaging.instance.subscribeToTopic("user").then((value) {
        log("subscribeToTopic done as user");
      });

    }catch(e){
      log("error 875 ${e.toString()}");
    }
  }

  Future<void> setDeviceToken() async {
    Get.find<AuthService>().user.value.deviceToken =
        await FirebaseMessaging.instance.getToken();
    _token = await FirebaseMessaging.instance.getToken();
  }

  Future<String> getToken() async {
    _token = await FirebaseMessaging.instance.getToken();
    return _token;
  }

  Future<void> sendPushMessage(String body,String body2) async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http
          .post(
        // Uri.parse('https://api.rnfirebase.io/messaging/send'),
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA7j9U9Yo:APA91bF9mbfJyfOGbaS1IDcRik-q3YKCjElMtokFL0vorHuQzJpbGPnhb8shpeaIgOhK6UEOlXQfdZpDbztcXS_aqlcZUDLcu2_JLO0U1K8Tnk7t3PvyznJPBoEElJVA59U8de2t47mZ',
        },
        body: constructFCMPayload(body,body2),
        encoding: Encoding.getByName('utf-8'),
      )
          .then((value) {
        log(value.body);
      });
      log('FCM request for device sent!');
    } catch (e) {
      log("error 474");
      log(e);
    }
  }

  String constructFCMPayload(String body,String body2) {
    return jsonEncode({
      // 'to': _token,
      // "topic": "admin",
      "to": "/topics/" + "admin2",
      "data": {
        "via": body2,
        "count": 1.toString(),
      },

      "android": {
        "priority": "high",
      },
      "priority": "high",
      'mutable_content': true,
      'content_available': true,
      "notification": {
        "title": "لديك طلب جديد",
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        "body": body+body2,
        "sound": "default",
        "badge": "1",
      },
    });
  }

  void _defaultNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    Get.showSnackbar(Ui.notificationSnackBar(
      title: notification.title,
      message: notification.body,
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    print(message.data);
    if (Get.find<MessagesController>().initialized) {
      Get.find<MessagesController>().refreshMessages();
    }
    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification.title,
        message: notification.body,
      ));
    }
  }
}

// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: require_trailing_commas

/// Manages & returns the users FCM token.
///
/// Also monitors token refreshes and updates state.
class TokenMonitor extends StatefulWidget {
  // ignore: public_member_api_docs
  TokenMonitor(this._builder);

  final Widget Function(String token) _builder;

  @override
  State<StatefulWidget> createState() => _TokenMonitor();
}

class _TokenMonitor extends State<TokenMonitor> {
  String _token;
  Stream<String> _tokenStream;

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getToken(
            // vapidKey:
            // 'BNKkaUWxyP_yC_lki1kYazgca0TNhuzt2drsOrL6WrgGbqnMnr8ZMLzg_rSPDm6HKphABS0KzjPfSqCXHXEd06Y'
            )
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(_token ?? "--");
  }
}
