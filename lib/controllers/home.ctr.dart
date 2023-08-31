import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_call_v2/models/location.doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

enum LoadStatus {
  loading,
  success,
  error,
}

final log = Logger(printer: PrettyPrinter());

final homeCtr = Get.put(HomeCtr());

class HomeCtr extends GetxService {
  final docUser = FirebaseFirestore.instance.collection("users");
  final docLocation = FirebaseFirestore.instance.collection("locations");
  final locs = <LocationDoc>[].obs;
  addUser() {
    try {
      docUser.add({'name': 'lee'});
    } catch (e) {
      log.e(e);
    }
  }

  addLocation(LatLng point) async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      await docLocation.add({
        'latitude': point.latitude,
        'longitude': point.longitude,
      });
      await Future.delayed(const Duration(seconds: 1));
      getLoactions();
    } catch (e) {
      log.e(e);
    }
    SmartDialog.dismiss();
  }

  getLoactions() async {
    SmartDialog.showLoading(msg: "Loading...");
    try {
      final r_locs = await docLocation.get();
      log.i(r_locs.docs.length);
      locs.value = r_locs.docs
          .map((e) => LocationDoc(
                id: e.id,
                latitude: e['latitude'],
                longitude: e['longitude'],
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
