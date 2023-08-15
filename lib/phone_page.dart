import 'package:emergency_call_v2/common.dart';
import 'package:emergency_call_v2/controllers/home_controller.dart';
import 'package:emergency_call_v2/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Book",
          style: TextStyle(color: AppColor.violet),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                "หมายเลขที่เกี่ยวข้องกับ\nCOVID-19",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: AppColor.violet,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
              child: Obx(
                () => homeController.phoneItemFilter.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: () async {
                          homeController.getPhones();
                        },
                        child: ListView.builder(
                          itemCount: homeController.phoneItemFilter.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  _makePhoneCall(homeController
                                      .phoneItemFilter[index].phone
                                      .toString());
                                },
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: AppColor.violet,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      homeController.phoneItemFilter[index].name
                                          .toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  homeController.phoneItemFilter[index].phone
                                      .toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          homeController.getPhones();
                        },
                        child: const Center(
                          child: Text("ไม่มีข้อมูล"),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
