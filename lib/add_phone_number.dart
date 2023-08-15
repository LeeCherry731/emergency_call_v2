import 'package:emergency_call_v2/common.dart';
import 'package:emergency_call_v2/controllers/home_controller.dart';
import 'package:emergency_call_v2/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPhoneNumberPage extends StatefulWidget {
  final String title;

  const AddPhoneNumberPage({super.key, required this.title});

  @override
  State<AddPhoneNumberPage> createState() => _AddPhoneNumberPageState();
}

class _AddPhoneNumberPageState extends State<AddPhoneNumberPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.violet),
        centerTitle: true,
        title: Text(
          "เพิ่มข้อมูล",
          style: TextStyle(color: AppColor.violet),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "เพิ่มข้อมูล ${widget.title}",
                style: TextStyle(
                  color: AppColor.violet,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "ชื่อ",
                  fillColor: Color.fromARGB(199, 255, 255, 255),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name) => name != null && name.length < 2
                    ? "ชื่อต้องไม่ต่ำกว่า 2 ตัวอักษร"
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "เบอร์โทร",
                  fillColor: Color.fromARGB(199, 255, 255, 255),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (name) {
                  if (name != null && name.length < 2) {
                    return "เบอร์โทรต้องไม่ต่ำกว่า 2 ตัวอักษร";
                  }

                  bool isNum = false;

                  try {
                    int.parse(name!);
                    isNum = true;
                  } catch (e) {
                    isNum = false;
                    return "กรุณากรอกตัวเลข";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(Get.width * 0.9, 50),
                  backgroundColor: AppColor.violet,
                ),
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (!isValid) return;
                  homeController.addPhone(
                      nameController.text, phoneController.text);
                },
                child: const Text(
                  "+ Add",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Obx(
                  () {
                    if (homeController.loadStatus.value == LoadStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (homeController.loadStatus.value == LoadStatus.error) {
                      return const Center(child: Text("Error"));
                    }

                    if (homeController.loadStatus.value == LoadStatus.success) {
                      return ListView.builder(
                        itemCount: homeController.phoneItemFilter.length,
                        itemBuilder: (context, i) => Align(
                          alignment: Alignment.center,
                          child: Card(
                            child: SizedBox(
                              width: Get.width,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: AppColor.violet,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      homeController.phoneItemFilter[i].name
                                          .toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  "เบอร์โทร : ${homeController.phoneItemFilter[i].phone.toString()}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    homeController.deletePhone(
                                        homeController.phoneItemFilter[i].id);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: AppColor.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
