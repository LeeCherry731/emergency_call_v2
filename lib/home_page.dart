import 'package:emergency_call_v2/account_page.dart';
import 'package:emergency_call_v2/comment_page.dart';
import 'package:emergency_call_v2/common.dart';
import 'package:emergency_call_v2/controllers/home_controller.dart';
import 'package:emergency_call_v2/edit_page.dart';
import 'package:emergency_call_v2/main.dart';
import 'package:emergency_call_v2/phone_page.dart';
import 'package:emergency_call_v2/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pagesUser = const [
    AccountPage(),
    PhonePage(),
    CommentPage(),
    ProfilePage(),
  ];
  final List<Widget> pagesAdimn = const [
    AccountPage(),
    PhonePage(),
    CommentPage(),
    EditPage(),
  ];

  final navsUser = [
    BottomNavigationBarItem(
      label: "Home",
      icon: Icon(
        Icons.home,
        color: AppColor.violet,
      ),
    ),
    BottomNavigationBarItem(
      label: "Phone",
      icon: Icon(
        Icons.phone,
        color: AppColor.violet,
      ),
    ),
    BottomNavigationBarItem(
      label: "Comment",
      icon: Icon(
        Icons.comment,
        color: AppColor.violet,
      ),
    ),
    BottomNavigationBarItem(
      label: "Profile",
      icon: Icon(
        Icons.person,
        color: AppColor.violet,
      ),
    ),
  ];
  final navsAdmin = [
    BottomNavigationBarItem(
      label: "Home",
      icon: Icon(
        Icons.home,
        color: AppColor.violet,
      ),
    ),
    BottomNavigationBarItem(
      label: "Phone",
      icon: Icon(
        Icons.phone,
        color: AppColor.violet,
      ),
    ),
    BottomNavigationBarItem(
      label: "Comment",
      icon: Icon(
        Icons.comment,
        color: AppColor.violet,
      ),
    ),
    BottomNavigationBarItem(
      label: "Edit",
      icon: Icon(
        Icons.edit,
        color: AppColor.violet,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => homeController.isAdmin.value
            ? pagesAdimn[homeController.currentIndex.value]
            : pagesUser[homeController.currentIndex.value],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          fixedColor: AppColor.violet,
          currentIndex: homeController.currentIndex.value,
          onTap: (index) => homeController.currentIndex.value = index,
          items: homeController.isAdmin.value ? navsAdmin : navsUser,
        ),
      ),
    );
  }
}
