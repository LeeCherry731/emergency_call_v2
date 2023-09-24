import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/comment.model.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/pages/news.page/news_add.page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<CommentPage> {
  final titleCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Comment".text.make(),
      ),
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
        stream: mainCtr.docComments.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: "ERROR".text.make());
          }
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final comments = snapshot.data!.docs
              .map(
                (e) => CommentModel(
                  id: e.id,
                  email: e['email'],
                  name: e['name'],
                  picture: e['picture'],
                  description: e['description'],
                  createdAt: e['createdAt'],
                ),
              )
              .sortedBy(
                (a, b) => DateTime.parse(b.createdAt).compareTo(
                  DateTime.parse(a.createdAt),
                ),
              )
              .toList();

          if (comments.isEmpty) {
            return Center(child: "ไม่มีข้อมูล".text.size(24).make());
          }

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, i) {
              final n = comments[i];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (n.picture == "")
                          CircleAvatar(
                            radius: 30.0,
                            child: "no img".text.make(),
                            backgroundColor: Colors.grey,
                          )
                        else
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              n.picture,
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        const SizedBox(width: 10),
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          elevation: 10,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "ชื่อ: ${n.name}"
                                          .text
                                          .minFontSize(18)
                                          .make(),
                                      SizedBox(
                                        width: Get.width * 0.64,
                                        child: n.description.text
                                            .size(11)
                                            .wrapWords(true)
                                            .make(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  "วันที่ ${n.getDate()}".text.make(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i + 1 == comments.length) const SizedBox(height: 200),
                ],
              );
            },
          );
        },
      ),
      bottomSheet: SizedBox(
        height: 60,
        width: Get.width,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: titleCtr,
              ),
            ),
            IconButton(
              onPressed: () async {
                if (titleCtr.text.trim() == "") {
                  return;
                }
                await mainCtr.addComment(title: titleCtr.text.trim());
                titleCtr.clear();
              },
              icon: const Icon(
                Icons.send,
                color: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
