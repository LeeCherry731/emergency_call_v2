import 'dart:io';

import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsAddPage extends StatefulWidget {
  const NewsAddPage({super.key});

  @override
  State<NewsAddPage> createState() => _NewsAddPageState();
}

class _NewsAddPageState extends State<NewsAddPage> {
  final formKey = GlobalKey<FormState>();

  final titleCtr = TextEditingController();
  final addressCtr = TextEditingController();
  final desCtr = TextEditingController();

  PlatformFile? pickedFile;

  @override
  void initState() {
    titleCtr.text = "title1";
    addressCtr.text = "addressCtr";
    desCtr.text = "desCtr";
    super.initState();
  }

  @override
  void dispose() {
    titleCtr.dispose();
    addressCtr.dispose();
    desCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   mainCtr.uploadPicNews();
      // }),
      appBar: AppBar(
        title: "News".text.make(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pickedFile == null)
                    InkWell(
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
                  if (pickedFile != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.file(
                            File(pickedFile!.path!),
                            width: 330,
                            height: 200,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                pickedFile = null;
                              });
                            },
                            icon: const Icon(
                              Icons.delete_sharp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "ชื่อเรื่อง".text.size(18).make(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          controller: titleCtr,
                          decoration: InputDecoration(
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "ชื่อเรื่อง",
                            fillColor: Colors.white70,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => name != null && name.length < 2
                              ? "ชื่อเรื่องต้องไม่ต่ำกว่า 2 ตัวอักษร"
                              : null,
                        ),
                      ),
                      "สถานที่".text.size(18).make(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          controller: addressCtr,
                          decoration: InputDecoration(
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "สถานที่",
                            fillColor: Colors.white70,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => name != null && name.length < 2
                              ? "สถานที่ต้องไม่ต่ำกว่า 2 ตัวอักษร"
                              : null,
                        ),
                      ),
                      "เนื้อเรื่อง".text.size(18).make(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          controller: desCtr,
                          maxLines: 8, //or null
                          decoration: InputDecoration(
                            isCollapsed: true,
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "ชื่อเรื่อง",
                            fillColor: Colors.white70,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => name != null && name.length < 2
                              ? "เนื้อเรื่องต้องไม่ต่ำกว่า 2 ตัวอักษร"
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      fixedSize: Size(Get.width * 0.9, 50),
                      backgroundColor: const Color.fromARGB(255, 194, 17, 173),
                    ),
                    onPressed: () async {
                      if (pickedFile == null) {
                        Get.defaultDialog(
                          title: "กรุณาเลือกรูปภาพ",
                          middleText: "กรุณาเลือกรูปภาพ",
                        );
                        return;
                      }
                      await mainCtr.addNews(
                          platformFile: pickedFile!,
                          title: titleCtr.text,
                          address: addressCtr.text,
                          description: desCtr.text);
                    },
                    child: const Text(
                      "เพิ่ม",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
