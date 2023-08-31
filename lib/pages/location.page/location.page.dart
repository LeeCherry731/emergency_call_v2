import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency_call_v2/controllers/home.ctr.dart';
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
    homeCtr.getLoactions();
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
            homeCtr.getLoactions();
          },
          child: ListView.builder(
            itemCount: homeCtr.locs.length,
            itemBuilder: (context, i) {
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                elevation: 10,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Location ${i + 1}".text.minFontSize(18).make(),
                            "Long : ${homeCtr.locs[i].latitude}".text.make(),
                            "Long : ${homeCtr.locs[i].longitude}".text.make(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        "วันที่ $i".text.make(),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () {
                        Get.to(() => const LocationDetailPage());
                      },
                      child: "ดู $i".text.make(),
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
