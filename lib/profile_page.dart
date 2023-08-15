import 'package:emergency_call_v2/auth_page.dart';
import 'package:emergency_call_v2/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "สวัสดี ${FirebaseAuth.instance.currentUser!.displayName ?? ""}",
          style: TextStyle(color: AppColor.violet),
        ),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => AuthPage());
            },
            child: Text(
              "Logout",
              style: TextStyle(color: AppColor.violet),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Align(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromARGB(255, 224, 224, 224),
                  child: Icon(
                    Icons.person_2_outlined,
                    color: AppColor.violet,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "ชื่อ",
                style: TextStyle(color: AppColor.violet),
              ),
              SizedBox(height: 5),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black45)),
                width: Get.width * 0.9,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${FirebaseAuth.instance.currentUser!.displayName ?? ""}",
                      style: TextStyle(color: AppColor.violet),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "อีเมล",
                style: TextStyle(color: AppColor.violet),
              ),
              SizedBox(height: 5),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black45)),
                width: Get.width * 0.9,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${FirebaseAuth.instance.currentUser!.email ?? ""}",
                      style: TextStyle(color: AppColor.violet),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: Get.width * 0.9,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.violet)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Get.offAll(() => AuthPage());
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: AppColor.violet),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
