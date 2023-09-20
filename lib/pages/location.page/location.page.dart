import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/pages/location.page/locaiton_detail.page.dart';
import 'package:emergency_call_v2/pages/location.page/location_add.page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
    mainCtr.getLoactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Get.to(() => const LocationAdd());
        },
        child: const Icon(
          Icons.plus_one,
          color: Colors.black,
          size: 35,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            mainCtr.getLoactions();
          },
          child: mainCtr.locs.isEmpty
              ? Center(
                  child: "ไม่มีข้อมูล".text.size(24).color(Colors.grey).make(),
                )
              : ListView.builder(
                  itemCount: mainCtr.locs.length,
                  itemBuilder: (context, i) {
                    final loc = mainCtr.locs[i];
                    return Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          elevation: 10,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    "assets/images/emergency_pic1.jpg",
                                    width: Get.width * 0.3,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "เรื่อง : ${loc.title}"
                                          .text
                                          .minFontSize(14)
                                          .make(),
                                      "ชื่อ : ${loc.name}".text.size(8).make(),
                                      "อีเมล : ${loc.email}"
                                          .text
                                          .size(8)
                                          .make(),
                                      "เบอร์ : ${loc.phone}"
                                          .text
                                          .size(8)
                                          .make(),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  "เวลา : ${loc.getDate()}".text.size(9).make(),
                                  "Lat : ${loc.latitude}".text.size(8).make(),
                                  "Long : ${loc.longitude}".text.size(8).make(),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                    ),
                                    onPressed: () {
                                      Get.to(() =>
                                          LocationDetailPage(location: loc));
                                    },
                                    child: "ดู".text.make(),
                                  ),
                                  "สถานะ".text.size(10).make(),
                                  "${loc.getStatus()}"
                                      .text
                                      .size(10)
                                      .color(loc.getColor())
                                      .make(),
                                ],
                              )
                            ],
                          ),
                        ),
                        if (mainCtr.locs.length == (i + 1))
                          const SizedBox(height: 100)
                      ],
                    );
                  },
                ),
        );
      }),
    );
  }
}
