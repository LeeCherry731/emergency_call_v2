import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/contact.model.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/models/news.model.dart';
import 'package:emergency_call_v2/pages/news.page/news_add.page.dart';
import 'package:emergency_call_v2/pages/news.page/news_detail.page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<ContactPage> {
  final contactTypes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: mainCtr.userModel.value.role != Role.admin
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Get.to(() => const NewsAddPage());
              },
              child: const Icon(
                Icons.plus_one,
                color: Colors.black,
                size: 35,
              ),
            ),
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: StreamBuilder(
        stream: mainCtr.docContacts.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: "ERROR".text.make());
          }
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final constacts = snapshot.data!.docs.map((e) {
            final data = e.data();
            final phones = data['phones'] as List;

            print(phones);
            final phoneModels = phones.map((p) {
              return Phone(name: p['name'] ?? "no", phone: p['phone'] ?? "no");
            }).toList();

            return ContactModel(
              id: e.id,
              name: data['name'],
              phones: phoneModels,
            );
          }).toList();

          if (constacts.isEmpty) {
            return Center(child: "ไม่มีข้อมูล".text.size(24).make());
          }

          return ListView.builder(
            itemCount: constacts.length,
            itemBuilder: (context, i) {
              final c = constacts[i];
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                elevation: 10,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ExpansionTile(
                    title: c.name.text.size(23).make(),
                    children: c.phones
                        .map(
                          (e) => InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: e.phone,
                              );
                              await launchUrl(launchUri);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  "${e.name} : ".text.size(20).make(),
                                  e.phone.text.size(20).make(),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList()),
              );
            },
          );
        },
      ),
    );
  }
}
