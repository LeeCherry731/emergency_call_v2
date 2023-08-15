import 'dart:async';

import 'package:emergency_call_v2/account_page.dart';
import 'package:emergency_call_v2/comment_page.dart';
import 'package:emergency_call_v2/common.dart';
import 'package:emergency_call_v2/controllers/home_controller.dart';
import 'package:emergency_call_v2/edit_page.dart';
import 'package:emergency_call_v2/main.dart';
import 'package:emergency_call_v2/phone_page.dart';
import 'package:emergency_call_v2/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Obx(
  //       () => homeController.isAdmin.value
  //           ? pagesAdimn[homeController.currentIndex.value]
  //           : pagesUser[homeController.currentIndex.value],
  //     ),
  //     bottomNavigationBar: Obx(
  //       () => BottomNavigationBar(
  //         fixedColor: AppColor.violet,
  //         currentIndex: homeController.currentIndex.value,
  //         onTap: (index) => homeController.currentIndex.value = index,
  //         items: homeController.isAdmin.value ? navsAdmin : navsUser,
  //       ),
  //     ),
  //   );
  // }

  List<TabItem> items = [
    TabItem(
      icon: Icons.home,
      // title: 'Home',
    ),
    TabItem(
      icon: Icons.search_sharp,
      title: 'Shop',
    ),
    TabItem(
      icon: Icons.favorite_border,
      title: 'Wishlist',
    ),
    TabItem(
      icon: Icons.account_box,
      title: 'profile',
    ),
  ];
  int visit = 0;
  double height = 30;
  Color colorSelect = const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const Color(0XFF1752FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Container(
        width: Get.width * 0.9,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              spreadRadius: 0.4,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: MapSample(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 30, right: 32, left: 32),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BottomBarFloating(
            items: items,
            borderRadius: BorderRadius.circular(60),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            color: const Color.fromARGB(255, 178, 50, 216),
            enableShadow: true,
            colorSelected: Color.fromARGB(255, 255, 15, 15),
            indexSelected: visit,
            onTap: (int index) => setState(() {
              visit = index;
            }),
          ),
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        child: const Icon(Icons.pin_drop_outlined),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
