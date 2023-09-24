import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/models/location.doc.dart';
import 'package:emergency_call_v2/models/user.model.dart';
import 'package:emergency_call_v2/pages/main.page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final docNews = FirebaseFirestore.instance.collection("news");
  final docContacts = FirebaseFirestore.instance.collection("contacts");
  final docComments = FirebaseFirestore.instance.collection("comments");
  final storageProfile = FirebaseStorage.instance.ref('profiles');
  final storageLocation = FirebaseStorage.instance.ref('locations');
  final storageNews = FirebaseStorage.instance.ref('news');
  final auth = FirebaseAuth.instance;

  final userModel = UserModel().obs;

  final locs = <LocationDoc>[].obs;

  Future<void> addUser({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
  }) async {
    try {
      final user = {
        "firstname": firstname,
        "lastname": lastname,
        "role": roleToString(Role.member),
        "email": email,
        "phone": phone,
        "picture": "",
        "createdAt": DateTime.now().toString(),
        "updatedAt": DateTime.now().toString(),
      };
      await docUser.add(user);
      await Future.delayed(const Duration(seconds: 1));
      await getUser(email: email);
      Get.offAll(() => const MainPage());
      // userDoc.snapshots().listen((event) {
      //   log.i(event.data());
      // });
    } catch (e) {
      log.e(e);
      snackError(title: "firebase auth error", msg: e.toString());
    }
  }

  Future getUser({required email}) async {
    try {
      final user = await docUser.get();
      userModel.value = user.docs
          .where((e) => e['email'] == email)
          .map((e) {
            final u = e.data();
            log.i(u);
            return UserModel()
              ..id = e.id
              ..email = u['email']
              ..firstname = u['firstname']
              ..lastname = u['lastname']
              ..role = stringToRole(u['role'])
              ..phone = u['phone']
              ..picture = u['picture']
              ..createdAt = u['createdAt'].toString()
              ..updatedAt = u['updatedAt'].toString();
          })
          .toList()
          .first;
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
      await getUser(email: email);
      await Get.offAll(() => const MainPage());
    } catch (e) {
      log.e(e);
      snackError(title: "firebase auth error", msg: e.toString());
    }
  }

  Future logout() async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      await auth.signOut();
      userModel.value = UserModel();
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const MainPage());
    } catch (e) {
      log.e(e);
      snackError(title: "firebase auth error", msg: e.toString());
    }
    SmartDialog.dismiss();
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String phone,
  }) async {
    SmartDialog.showLoading(msg: "Loading...");

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
      );
      Get.offAll(() => const MainPage());
    } catch (e) {
      log.e(e);
      snackError(title: "firebase auth error", msg: e.toString());
    }
    SmartDialog.dismiss();
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
    } catch (e) {
      log.e(e);
    }
    SmartDialog.dismiss();
  }

  Future<void> addComment({
    required String title,
  }) async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      await docComments.add({
        'email': userModel.value.email,
        'name': userModel.value.firstname,
        'picture': userModel.value.picture,
        'description': title,
        'createdAt': DateTime.now().toString()
      });
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      log.e(e);
    }
    SmartDialog.dismiss();
  }

  Future uploadDateProfile({required PlatformFile platformFile}) async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      final path = platformFile.name;
      final file = File(platformFile.path!);

      final ref = storageProfile.child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();
      log.i(urlDownload);

      docUser.doc(userModel.value.id).update({"picture": urlDownload});
      getUser(email: userModel.value.email);
    } catch (e) {
      log.e(e.toString());
    }

    SmartDialog.dismiss();
  }

  Future staffChooseLocation({required String id}) async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      docLocation.doc(id).update({"status": "going"});
      getUser(email: userModel.value.email);
    } catch (e) {
      log.e(e.toString());
    }

    SmartDialog.dismiss();
  }

  Future uploadPicLocaiton() async {}
  Future addNews(
      {required PlatformFile platformFile,
      required String title,
      required String address,
      required String description}) async {
    try {
      SmartDialog.showLoading(msg: "Loading...");

      final path = platformFile.name;
      final file = File(platformFile.path!);

      final ref = storageNews.child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();
      log.i(urlDownload);

      await docNews.add({
        'email': userModel.value.email,
        'name': userModel.value.firstname,
        'title': title,
        'description': description,
        'phone': userModel.value.phone,
        'address': address,
        'image': urlDownload,
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      });

      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (e) {
      log.e(e.toString());
    }

    SmartDialog.dismiss();
  }

  snackError({required title, required msg}) {
    log.i("snackError");

    Get.snackbar(
      title,
      msg,
      backgroundColor: const Color.fromARGB(255, 233, 45, 45),
      colorText: Colors.white,
    );
  }

  // Future<void> getLostData() async {
  //   final ImagePicker picker = ImagePicker();
  //   final LostDataResponse response = await picker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   final List<XFile>? files = response.files;
  //   if (files != null) {
  //     _handleLostFiles(files);
  //   } else {
  //     _handleError(response.exception);
  //   }
  // }
}
