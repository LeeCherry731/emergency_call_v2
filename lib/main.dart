import 'dart:io';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emergency_call_v2/controllers/notification.ctr.dart';
import 'package:emergency_call_v2/controllers/socketio.dart';
import 'package:emergency_call_v2/pages/main.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeService();

  await NotificationService.initializeNotification();
  await NotiCtr.initializeLocalNotifications();
  await NotiCtr.initializeIsolateReceivePort();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Color mainColor = const Color(0xFF9D50DD);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Emergency phone',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
      theme: ThemeData(
        fontFamily: GoogleFonts.kanit().fontFamily,
        primarySwatch: Colors.blue,
        // useMaterial3: true,
      ),
      // home: const AuthPage(),
      home: const MainPage(),
      // home: PlaceMarkerPage(),
    );
  }
}

Map<String, String> headers = {
  'token': token,
  'memberId': "E0673DE2-1EF1-4240-95D1-6546D583CED6"
};
IO.Socket? socket = IO.io(ip_prod, <String, dynamic>{
  'transports': ['websocket'],
  'extraHeaders': headers,
});

const ip_prod = "https://socketa1.ausirisnext.com/pushNotiNsp";
const ip_local = "http://192.168.1.134:3000";
const token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIwOTQ0Njk0Zi02ZmE5LTRiZGItYjIyYy1iMjkxYjQyMTJkMmQiLCJ1bmlxdWVfbmFtZSI6Im1ob29udW1AZ21haWwuY29tIiwidGtleSI6Im53dVZVSTAwM2xjaHpodExBMkhHR3JrV1JNSXRhNUFSV2d4TmJqbkVTR1ZCTGxkTVo0MVlaYmpxUkVhdkRoTlB2cy80TjFXdlRPdHhYUUhUY3NOZHN3PT0iLCJ1c2VyVHlwZSI6IiIsImNsaWVudElEIjoiIiwic2NoZW1hIjoiRiIsIm5iZiI6MTY5NjM5MjQxNywiZXhwIjoxNjk2NDAzMjE3LCJpYXQiOjE2OTYzOTI0MTcsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3QiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0In0.4059b_Wn3PpGbcSjHBY-5oFKTxxSV8X50HhFNNVs37o";

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  try {
    Map<String, String> headers = {
      'token': token,
      'memberId': "E0673DE2-1EF1-4240-95D1-6546D583CED6"
    };

    socket = IO.io(ip_prod, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': headers,
    });

    socket?.connect();
    socket?.onConnect((data) {
      print(socket?.connected);
      socket?.on('noti', (data) async {
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // final role = prefs.getString("role");
        // print('role: $role');

        // if (role == null || role == "") return;

        await NotificationService.showNotification(
          title: data["title"],
          body: data["message"],
        );
      });
    });
  } catch (e) {
    print(e);
  }
}

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: false,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      // MyApp.navigatorKey.currentState?.push(
      //   MaterialPageRoute(
      //     builder: (_) => const SecondScreen(),
      //   ),
      // );
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        icon: "resource://drawable/emer_icon",
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}
