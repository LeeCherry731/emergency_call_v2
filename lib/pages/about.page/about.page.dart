import 'package:emergency_call_v2/pages/about.page/account.page.dart';
import 'package:emergency_call_v2/pages/auth.page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: "เกี่ยวกับ".text.minFontSize(25).color(Colors.purple).make(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.purpleAccent,
            height: 4.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 10,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              height: 80,
              child: Center(
                child: ListTile(
                  onTap: () => {Get.to(() => const AccountPage())},
                  title: "บัญชีผู้ใช้".text.minFontSize(22).make(),
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 10,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              height: 80,
              child: Center(
                child: ListTile(
                  title: "Feedback".text.minFontSize(22).make(),
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.message_rounded,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 194, 17, 173),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              fixedSize: Size(
                Get.width * 0.8,
                60,
              ),
            ),
            onPressed: () => {
              Get.defaultDialog(
                  title: "",
                  titlePadding: EdgeInsets.zero,
                  content: SizedBox(
                    width: Get.width * 0.8,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              "assets/icon/icon.png",
                              height: 200,
                            ),
                            "คุณต้องการออกจากระบบหรือไม่"
                                .text
                                .minFontSize(20)
                                .make(),
                          ],
                        ),
                        Column(
                          children: [
                            const Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 194, 17, 173),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    fixedSize: const Size(
                                      100,
                                      50,
                                    ),
                                  ),
                                  onPressed: () =>
                                      {Get.offAll(() => const AuthPage())},
                                  child: "ยืนยัน".text.minFontSize(20).make(),
                                ),
                                TextButton(
                                  onPressed: () => {Get.back()},
                                  child: "ยกเลิก"
                                      .text
                                      .minFontSize(20)
                                      .color(Colors.black)
                                      .make(),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            },
            child: "ออกจากระบบ".text.minFontSize(20).make(),
          ),
        ],
      ),
    );
  }
}
