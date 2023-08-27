import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, i) {
          return Card(
            color: Colors.white,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 10,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/emergency_pic1.jpg",
                          width: 80,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    "เหตุด่วนเหตุร้าย $i".text.minFontSize(18).make(),
                  ],
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "LocationPage $i".text.minFontSize(18).make(),
                            "LocationPage $i".text.make(),
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
                      onPressed: () {},
                      child: "ดู $i".text.make(),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
