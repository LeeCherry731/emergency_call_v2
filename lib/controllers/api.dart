import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

final api = FirebaseApi();

class FirebaseApi {
  final _fcm = FirebaseMessaging.instance;

  Future<void> getFcmToken() async {
    await _fcm.requestPermission();

    final fcmToken = await _fcm.getToken();

    print('Token: $fcmToken');
  }

  Future<void> sent() async {
    try {
      const fcmToken2 =
          "dI799z_TSOmstdrK-JdTdl:APA91bFaxMzak_8Zzij5OJfU-3z6s9e1Q8jScmjQklFtmGjAfaYL9Vq9ezwC4dnKC8XROf4DGmNYOG7LkZUzPdG5ud0FvhHgZGUxGMPldDIt-5LmLu14reCcEGxeIpiV3E-oCb05vAYS";

      final fcmToken = await _fcm.getToken();
      await _fcm.sendMessage(to: fcmToken2, data: {
        "title": "titlee",
        "body": "bodyy",
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sent2() async {
    try {
      const fcmToken2 =
          "dI799z_TSOmstdrK-JdTdl:APA91bFaxMzak_8Zzij5OJfU-3z6s9e1Q8jScmjQklFtmGjAfaYL9Vq9ezwC4dnKC8XROf4DGmNYOG7LkZUzPdG5ud0FvhHgZGUxGMPldDIt-5LmLu14reCcEGxeIpiV3E-oCb05vAYS";

      final fcmToken = await _fcm.getToken();
      await _fcm.sendMessage();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postMsg() async {
    const id = "push-notification-6ce90";
    const token = "ade892ec01ecdfd6cec5b6e2f5744a7aa147bb03";
    final url = Uri.parse('https://fcm.googleapis.com/v1/$id/messages:send');

    print(url.toString());

    final headers = {'Authorization': 'Bearer $token'};
    final fcmToken = await _fcm.getToken();

    print('Token: $fcmToken');

    const fcmToken2 =
        "dI799z_TSOmstdrK-JdTdl:APA91bFaxMzak_8Zzij5OJfU-3z6s9e1Q8jScmjQklFtmGjAfaYL9Vq9ezwC4dnKC8XROf4DGmNYOG7LkZUzPdG5ud0FvhHgZGUxGMPldDIt-5LmLu14reCcEGxeIpiV3E-oCb05vAYS";

    final body = jsonEncode({
      'message': {
        "token": fcmToken,
        "notification": {
          "title": "titlee",
          "body": "bodyy",
          "image": 'https://example.com/image.png'
        },
        "data": {
          "key1": "val1",
          "key2": "val2",
        }
      },
    });
    final req = await http.post(url, headers: headers, body: body);

    print("-------------------");
    print(req.statusCode);
    print(req.body);
    print("-------------------");

    // final res = jsonDecode(req.body);
  }
}
