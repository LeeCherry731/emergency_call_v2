import 'package:emergency_call_v2/add_phone_number.dart';
import 'package:emergency_call_v2/common.dart';
import 'package:emergency_call_v2/controllers/home_controller.dart';
import 'package:emergency_call_v2/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit",
          style: TextStyle(color: AppColor.violet),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                "แก้ไขข้อมูล",
                style: TextStyle(color: AppColor.violet, fontSize: 18),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: homeController.categoryItems.length, //จำนวน
                  itemBuilder: (context, i) => Align(
                    alignment: Alignment.center,
                    child: Card(
                      child: SizedBox(
                        width: Get.width,
                        child: ListTile(
                          onTap: () {
                            homeController.nameFilter.value =
                                homeController.categoryItems[i];
                            homeController.filterByName();
                            Get.to(() => AddPhoneNumberPage(
                                  title: homeController.categoryItems[i],
                                ));
                          },
                          title: Text(
                              "แก้ไขข้อมูล ${homeController.categoryItems[i]}"),
                          trailing: Icon(
                            Icons.edit,
                            color: AppColor.violet,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
