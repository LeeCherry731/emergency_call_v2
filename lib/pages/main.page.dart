import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:emergency_call_v2/pages/about.page.dart';
import 'package:emergency_call_v2/pages/contact.page.dart';
import 'package:emergency_call_v2/pages/home.page.dart';
import 'package:emergency_call_v2/pages/location.page.dart';
import 'package:emergency_call_v2/pages/news.page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<TabItem> items = const [
    TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    TabItem(
      icon: Icons.pin_drop,
      title: 'Location',
    ),
    TabItem(
      icon: Icons.newspaper,
      title: 'News',
    ),
    TabItem(
      icon: Icons.account_box,
      title: 'Contact',
    ),
    TabItem(
      icon: Icons.person_2,
      title: 'About',
    ),
  ];

  final pages = const [
    HomePage(),
    LocationPage(),
    NewsPage(),
    ContactPage(),
    AboutPage(),
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
