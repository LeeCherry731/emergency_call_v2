import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_call_v2/common.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('Messages')
      .orderBy('time')
      .snapshots();
  final TextEditingController message = TextEditingController();
  final fs = FirebaseFirestore.instance;
  String token = "";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value ?? "";
      });
    });
  }

  void sendPushMessage() async {
    var title = "title";
    var body = "body";
    try {
      final req = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        encoding: Encoding.getByName('utf-8'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              "key=AAAAgbZyQp4:APA91bEvzt3WFvk-W-LZ7ttKuQH1MhCFreSj5A7KPG5N3kMM8755qBYIy1DBtK_eSiBCF-GZgR4m_3dH1plSnues_zkWI3_A-6p0w1da6odrYPYaqtK8WWqCtjlubcMgsgcAvkEHzcpQ",
        },
        body: jsonEncode(
          {
            'priority': 'high',
            'data': {
              'id': '28',
              'type': 'Order',
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              // 'body': body,
              // 'title': title,
            },
            "notification": {
              "title": title,
              "body": body,
              // "android_channel_id": "emergency_call_v2",
            },
            "to": "topics/myTopic",
          },
        ),
      );

      debugPrint(req.statusCode.toString());
      debugPrint(req.body);
    } catch (e) {
      debugPrint("http post error : $e");
    }
  }

  // test() async {
  //   BigTextStyleInformation bigText = BigTextStyleInformation(
  //     "title test",
  //     htmlFormatContent: true,
  //     contentTitle: "contentTitle test",
  //     htmlFormatContentTitle: true,
  //   );

  //   AndroidNotificationDetails android = AndroidNotificationDetails(
  //     "emergency_call_v2",
  //     "sdfsd",
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     playSound: true,
  //   );

  //   NotificationDetails platformChannel = NotificationDetails(
  //     android: android,
  //     iOS: const IOSNotificationDetails(),
  //   );

  //   await FlutterLocalNotificationsPlugin().show(
  //     0,
  //     "title test",
  //     "body test",
  //     platformChannel,
  //     payload: "body test",
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // await FirebaseMessaging.instance.subscribeToTopic("myTopic");
    // onRequestPermission();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     BigTextStyleInformation bigText = BigTextStyleInformation(
    //       message.notification!.body.toString(),
    //       htmlFormatContent: true,
    //       contentTitle: message.notification!.title.toString(),
    //       htmlFormatContentTitle: true,
    //     );

    //     AndroidNotificationDetails android = AndroidNotificationDetails(
    //       "emergency_call_v2",
    //       "emergency_call_v2",
    //       "",
    //       importance: Importance.high,
    //       priority: Priority.high,
    //       playSound: true,
    //     );

    //     NotificationDetails platformChannel = NotificationDetails(
    //       android: android,
    //       iOS: const IOSNotificationDetails(),
    //     );

    //     await FlutterLocalNotificationsPlugin().show(
    //       0,
    //       message.notification!.title,
    //       message.notification!.body,
    //       platformChannel,
    //       payload: message.data['body'],
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ข้อเสนอแนะ",
          style: TextStyle(color: AppColor.violet),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: TextFormField(
                controller: message,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "ข้อความ",
                  fillColor: Color.fromARGB(199, 255, 255, 255),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(50, 60),
                  backgroundColor: AppColor.violet,
                ),
                onPressed: () {},
                child: Text(
                  "ส่ง",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Material(
          color: Colors.white,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: StreamBuilder(
                stream: _messageStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("something is wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.length == 0) {
                    return Center(child: Text("ไม่มีข้อความ"));
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        primary: true,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          QueryDocumentSnapshot qs = snapshot.data!.docs[index];
                          Timestamp t = qs['time'];
                          DateTime d = t.toDate();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      qs['email'],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    qs['message'],
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "Like",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.favorite,
                                      color: AppColor.violet,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
