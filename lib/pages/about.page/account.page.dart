import 'dart:io';

import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  PlatformFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "ข้อมูลส่วนตัว".text.minFontSize(18).make(),
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (mainCtr.userModel.value.picture != "")
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          mainCtr.userModel.value.picture,
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                if (pickedFile == null && mainCtr.userModel.value.picture == "")
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        onTap: () async {
                          final pic = await FilePicker.platform.pickFiles();
                          if (pic == null) return;
                          setState(() {
                            pickedFile = pic.files.first;
                          });
                        },
                        child: Image.asset(
                          "assets/images/addPic.png",
                          width: 330,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                if (pickedFile != null && mainCtr.userModel.value.picture == "")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.file(
                          File(pickedFile!.path!),
                          width: 330,
                          height: 200,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (pickedFile == null) {
                              Get.defaultDialog(
                                title: "กรุณาเลือกรูปภาพ",
                                middleText: "กรุณาเลือกรูปภาพ",
                              );
                              return;
                            }

                            await mainCtr.uploadDateProfile(
                                platformFile: pickedFile!);
                          },
                          child: "อัพเดพ".text.make(),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          "ID : ".text.size(18).make(),
                          mainCtr.userModel.value.id.text.size(18).make(),
                        ],
                      ),
                      Row(
                        children: [
                          "สถานะ : ".text.size(18).make(),
                          mainCtr.userModel.value.status.text.size(18).make(),
                        ],
                      ),
                      Row(
                        children: [
                          "ชื่อจริง : ".text.size(18).make(),
                          mainCtr.userModel.value.firstname.text
                              .size(18)
                              .make(),
                        ],
                      ),
                      Row(
                        children: [
                          "นามสกุล : ".text.size(18).make(),
                          mainCtr.userModel.value.lastname.text.size(18).make(),
                        ],
                      ),
                      Row(
                        children: [
                          "Role : ".text.size(18).make(),
                          roleToString(mainCtr.userModel.value.role)
                              .text
                              .size(18)
                              .make(),
                        ],
                      ),
                      Row(
                        children: [
                          "วันที่สมัคร : ".text.size(18).make(),
                          mainCtr.userModel.value
                              .getDate()
                              .text
                              .size(18)
                              .make(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
