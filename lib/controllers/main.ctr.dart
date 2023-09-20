import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/models/location.doc.dart';
import 'package:emergency_call_v2/models/user.model.dart';
import 'package:emergency_call_v2/pages/main.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoadStatus {
  loading,
  success,
  error,
}

final log = Logger(printer: PrettyPrinter());

final mainCtr = Get.put(MainCtr());

class MainCtr extends GetxService {
  final docUser = FirebaseFirestore.instance.collection("users");
  final docLocation = FirebaseFirestore.instance.collection("locations");
  final auth = FirebaseAuth.instance;

  final userModel = UserModel().obs;

  final locs = <LocationDoc>[].obs;

  Future<void> addUser({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String picture,
  }) async {
    try {
      final user = {
        "firstname": firstname,
        "lastname": lastname,
        "role": roleToString(Role.member),
        "email": email,
        "phone": phone,
        "picture": picture,
      };

      final userDoc = await docUser.add(user);

      userDoc.snapshots().listen((event) {
        log.i(event.data());
      });
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      await Get.offAll(() => const MainPage());
    } catch (e) {
      log.e(e);
      snackError(title: "firebase auth error", msg: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String phone,
    required String picture,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUser(
        firstname: firstname,
        lastname: lastname,
        email: email,
        phone: phone,
        picture: picture,
      );
      Get.offAll(() => const MainPage());
    } catch (e) {
      log.e(e);
      snackError(title: "firebase auth error", msg: e.toString());
    }
  }

  Future<void> addLocation(
    LatLng point, {
    required String email,
    required String name,
    required String title,
    required String phone,
  }) async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      await docLocation.add({
        'email': email,
        'name': name,
        'title': title,
        'phone': phone,
        'status': "waiting",
        'latitude': point.latitude,
        'longitude': point.longitude,
        'createdAt': DateTime.now().toString()
      });
      await Future.delayed(const Duration(seconds: 1));
      getLoactions();
    } catch (e) {
      log.e(e);
    }
    SmartDialog.dismiss();
  }

  Future<void> getLoactions() async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      final r_locs = await docLocation.get();
      log.i(r_locs.docs.length);
      locs.value = r_locs.docs
          .map((e) => LocationDoc(
                id: e.id,
                latitude: e['latitude'],
                longitude: e['longitude'],
                email: e['email'],
                name: e['name'],
                title: e['title'],
                phone: e['phone'],
                status: e['status'],
                createdAt: e['createdAt'],
              ))
          .toList();
    } catch (e) {
      log.e(e);
    }
    SmartDialog.dismiss();
  }

  snackError({required title, required msg}) {
    log.i("snackError");

    Get.snackbar(title, msg,
        backgroundColor: const Color.fromARGB(255, 233, 45, 45),
        colorText: Colors.white);
  }
}
