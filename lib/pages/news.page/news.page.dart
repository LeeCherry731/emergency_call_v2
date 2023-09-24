import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/models/news.model.dart';
import 'package:emergency_call_v2/pages/news.page/news_add.page.dart';
import 'package:emergency_call_v2/pages/news.page/news_detail.page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: mainCtr.userModel.value.role == Role.admin ||
              mainCtr.userModel.value.role == Role.member
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Get.to(() => const NewsAddPage());
              },
              child: const Icon(
                Icons.plus_one,
                color: Colors.black,
                size: 35,
              ),
            )
          : null,
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: StreamBuilder(
        stream: mainCtr.docNews.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: "ERROR".text.make());
          }
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final news = snapshot.data!.docs
              .map(
                (e) => NewsModel(
                  id: e.id,
                  email: e['email'],
                  name: e['name'],
                  title: e['title'],
                  phone: e['phone'],
                  address: e['address'],
                  status: e['status'],
                  image: e['image'],
                  description: e['description'],
                  createdAt: e['createdAt'],
                  updatedAt: e['updatedAt'],
                ),
              )
              .filter((e) {
                if (mainCtr.userModel.value.role == Role.admin) {
                  return true;
                } else {
                  return e.status == "approved";
                }
              })
              .sortedBy(
                (a, b) => DateTime.parse(b.createdAt).compareTo(
                  DateTime.parse(a.createdAt),
                ),
              )
              .toList();

          if (news.isEmpty) {
            return Center(child: "ไม่มีข้อมูล".text.size(24).make());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, i) {
                  final n = news[i];

                  return Column(
                    children: [
                      const Divider(),
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            if (mainCtr.userModel.value.role == Role.admin)
                              SlidableAction(
                                onPressed: (v) {
                                  mainCtr.disapproveNews(id: n.id);
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'DisApprove',
                              ),
                            if (mainCtr.userModel.value.role == Role.admin)
                              SlidableAction(
                                onPressed: (v) {
                                  mainCtr.approveNews(id: n.id);
                                },
                                backgroundColor: const Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                label: 'Approved',
                              ),
                            if (mainCtr.userModel.value.role != Role.admin)
                              SlidableAction(
                                onPressed: (v) {
                                  Get.to(() => NewsDetailPage(news: n));
                                },
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                label: 'อ่าน',
                              ),
                          ],
                        ),
                        child: SizedBox(
                          child: ListTile(
                            trailing: n.status == "approved"
                                ? const Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.red,
                                  ),
                            title: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    n.image,
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        "ชื่อเรื่อง: ${n.title}"
                                            .text
                                            .minFontSize(18)
                                            .make(),
                                        "ที่อยู่: ${n.address}".text.make(),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    "วันที่ ${n.getDate()}"
                                        .text
                                        .size(10)
                                        .make(),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.to(() => NewsDetailPage(news: n));
                            },
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                  // return InkWell(
                  //   onTap: () {
                  //     Get.to(() => NewsDetailPage(news: n));
                  //   },
                  //   child: Card(
                  //     shape: RoundedRectangleBorder(
                  //       side: BorderSide(
                  //         color: Theme.of(context).colorScheme.outline,
                  //       ),
                  //       borderRadius: const BorderRadius.all(Radius.circular(15)),
                  //     ),
                  //     elevation: 10,
                  //     margin:
                  //         const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //     child: Row(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(10),
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.circular(8),
                  //             child: Image.network(
                  //               n.image,
                  //               width: 100,
                  //               height: 100,
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(width: 10),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 "ชื่อเรื่อง: ${n.title}"
                  //                     .text
                  //                     .minFontSize(18)
                  //                     .make(),
                  //                 "ที่อยู่: ${n.address}".text.make(),
                  //               ],
                  //             ),
                  //             const SizedBox(height: 10),
                  //             "วันที่ ${n.getDate()}".text.make(),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  // ),
                  // );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
