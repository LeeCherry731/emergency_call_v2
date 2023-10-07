import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/controllers/socketio.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/pages/about.page/about.page.dart';
import 'package:emergency_call_v2/pages/admin/admin.page.dart';
import 'package:emergency_call_v2/pages/auth.page.dart';
import 'package:emergency_call_v2/pages/contact.page/contact.page.dart';
import 'package:emergency_call_v2/pages/home.page.dart';
import 'package:emergency_call_v2/pages/location.page/location.page.dart';
import 'package:emergency_call_v2/pages/news.page/news.page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<TabItem> items = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    if (mainCtr.userModel.value.role != Role.none)
      const TabItem(
        icon: Icons.pin_drop,
        title: 'Location',
      ),
    const TabItem(
      icon: Icons.newspaper,
      title: 'News',
    ),
    const TabItem(
      icon: Icons.account_box,
      title: 'Contact',
    ),
    const TabItem(
      icon: Icons.person_2,
      title: 'About',
    ),
    if (mainCtr.userModel.value.role == Role.admin)
      const TabItem(
        icon: Icons.person_pin_rounded,
        title: 'users',
      ),
  ];

  final pages = [
    const HomePage(),
    if (mainCtr.userModel.value.role != Role.none) const LocationPage(),
    const NewsPage(),
    const ContactPage(),
    const AboutPage(),
    if (mainCtr.userModel.value.role == Role.admin) const AdminPage(),
  ];

  int indexPage = 0;
  double height = 30;
  Color colorSelect = const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const Color(0XFF1752FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () {
                socketio.init();
              },
            ),
            FloatingActionButton(onPressed: () {
              socketio.sentNoti();
            }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Obx(
          () => mainCtr.userModel.value.firstname.text
              .size(20)
              .color(Colors.white)
              .make(),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 207, 12, 129),
      ),
      drawer: const NavigationDrawer(),
      extendBody: false,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: pages[indexPage],
      bottomNavigationBar: BottomBarDivider(
        items: items,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: const Color.fromARGB(255, 178, 50, 216),
        enableShadow: true,
        colorSelected: const Color.fromARGB(255, 255, 15, 15),
        indexSelected: indexPage,
        onTap: (int index) => setState(() {
          indexPage = index;
        }),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/icon/icon.png"),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: "Home".text.size(20).make(),
                onTap: () {
                  Get.offAll(() => const MainPage());
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.login),
                title: "เข้าสู่ระบบ".text.size(20).make(),
                onTap: () {
                  Get.to(() => const AuthPage());
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: "ออกจากระบบ".text.size(20).make(),
                onTap: () {
                  mainCtr.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
