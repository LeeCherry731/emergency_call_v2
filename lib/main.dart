import 'package:emergency_call_v2/pages/auth.page.dart';
import 'package:emergency_call_v2/controllers/home.ctr.dart';
import 'package:emergency_call_v2/pages/examples/map.exp.dart';
import 'package:emergency_call_v2/pages/main.page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Emergency phone',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(
          //default toast widget
          // toastBuilder: (String msg) => CustomToastWidget(msg: msg),
          //default loading widget
          // loadingBuilder: (String msg) => CustomLoadingWidget(msg: msg),
          ),
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
