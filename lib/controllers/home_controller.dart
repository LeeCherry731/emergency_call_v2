import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum LoadStatus {
  loading,
  success,
  error,
}

class HomeController extends GetxService {
  var isAdmin = false.obs;

  // HomeController get to => Get.find();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController inputPhone = TextEditingController();

  CollectionReference phones = FirebaseFirestore.instance.collection('phones');
  CollectionReference categorys = FirebaseFirestore.instance.collection('categorys');

  var currentIndex = 0.obs;

  var loadStatus = LoadStatus.success.obs;

  var categoryItems = <String>[].obs;
  var phoneItems = <Phone>[].obs;
  var phoneItemFilter = <Phone>[].obs;
  var nameFilter = "".obs;

  filterByName() {
    phoneItemFilter.value = phoneItems
        .where((p) => p.categoryName == nameFilter.value && nameFilter.value != "")
        .toList();
    // print(nameFilter.value);
    // print(phoneItems.value);
  }

  getCategorys() {
    print("getCategorys");
    categorys.get().then((value) {
      categoryItems.value = value.docs.map((e) => "${e["name"]}").toList();
    });
  }

  getPhones() async {
    // print("getPhones");
    await phones.get().then((value) {
      // print(value.docs[0].data());
      final dataList = value.docs
          .map((e) => Phone(
                id: e.id,
                categoryName: e["category_name"],
                name: e["name"],
                phone: e["phone"],
              ))
          .toList();
      phoneItems.value = dataList;
      phoneItemFilter.value = dataList;
    });
    filterByName();
  }

  addPhone(String name, String phone) async {
    loadStatus.value = LoadStatus.loading;
    final addInfo = await phones.add({
      "category_name": nameFilter.value,
      "name": name,
      "phone": phone,
    });
    // print("addInfo ${addInfo}");
    await Future.delayed(const Duration(seconds: 1));
    getPhones();
    loadStatus.value = LoadStatus.success;
  }

  deletePhone(String id) async {
    loadStatus.value = LoadStatus.loading;
    await phones.doc(id).delete();
    await Future.delayed(const Duration(seconds: 1));
    getPhones();
    loadStatus.value = LoadStatus.success;
  }
}

class Phone {
  String id;
  String categoryName;
  String name;
  String phone;

  Phone({
    required this.id,
    required this.categoryName,
    required this.name,
    required this.phone,
  });
}
