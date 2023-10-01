import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/models/enum.dart';
import 'package:emergency_call_v2/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: StreamBuilder(
        stream: mainCtr.docUser.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: "ERROR".text.make());
          }
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs
              .map((e) {
                final u = e.data();
                return UserModel()
                  ..id = e.id
                  ..email = u['email']
                  ..firstname = u['firstname']
                  ..lastname = u['lastname']
                  ..role = stringToRole(u['role'])
                  ..phone = u['phone']
                  ..status = u['status'] ?? "waiting"
                  ..picture = u['picture']
                  ..createdAt = u['createdAt'].toString()
                  ..updatedAt = u['updatedAt'].toString();
              })
              .filter((e) {
                if (e.role == Role.admin) {
                  return false;
                }
                return true;
              })
              .sortedBy(
                (a, b) => DateTime.parse(b.createdAt).compareTo(
                  DateTime.parse(a.createdAt),
                ),
              )
              .toList();

          if (users.isEmpty) {
            return Center(child: "ไม่มีข้อมูล".text.size(24).make());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  final n = users[i];

                  return Column(
                    children: [
                      const Divider(),
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (v) {
                                mainCtr.disapproveUser(id: n.id);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'DisApprove',
                            ),
                            SlidableAction(
                              onPressed: (v) {
                                mainCtr.approveUser(id: n.id);
                              },
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.check,
                              label: 'Approved',
                            ),
                            // if (mainCtr.userModel.value.role != Role.admin)
                            //   SlidableAction(
                            //     onPressed: (v) {},
                            //     backgroundColor: Colors.green,
                            //     foregroundColor: Colors.white,
                            //     icon: Icons.check,
                            //     label: 'อ่าน',
                            //   ),
                          ],
                        ),
                        child: SizedBox(
                          child: ListTile(
                            trailing: n.status == "none"
                                ? const Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.grey,
                                  )
                                : n.status == "approved"
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
                                if (n.picture == "")
                                  CircleAvatar(
                                    backgroundColor: Colors.pink,
                                    child: "ไม่มีรูป".text.make(),
                                  )
                                else
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      n.picture,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          "ชื่อ: ${n.firstname} ${n.lastname}"
                                              .text
                                              .minFontSize(18)
                                              .make(),
                                          "เบอร์: ${n.phone}".text.make(),
                                        ],
                                      ),
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
                            onTap: () {},
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
