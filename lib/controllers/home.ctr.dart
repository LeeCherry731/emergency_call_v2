import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum LoadStatus {
  loading,
  success,
  error,
}

final log = Logger(printer: PrettyPrinter());

final homeCtr = Get.put(HomeCtr());

class HomeCtr extends GetxService {
  addLoctionDoc() {
    log.i("addLoctionDoc");
  }

  snackError({required title, required msg}) {
    log.i("snackError");

    Get.snackbar(title, msg, backgroundColor: Colors.redAccent);
  }
}
