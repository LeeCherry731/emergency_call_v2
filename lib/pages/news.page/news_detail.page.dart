import 'package:emergency_call_v2/models/news.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsModel news;
  const NewsDetailPage({required this.news, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: news.title.text.make()),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      news.image,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "ชื่อเรื่อง: ${news.title}".text.minFontSize(18).make(),
                        "ที่อยู่: ${news.address}".text.make(),
                        "เนื้อเรื่อง:".text.make(),
                        Card(
                          child: Container(
                            width: double.maxFinite,
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: news.description.text.make(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    "วันที่ ${news.getDate()}".text.make(),
                    "ชื้อผู้แต่ง ${news.name}".text.make(),
                    "อีเมลผู้แต่ง ${news.email}".text.make(),
                    "เบอร์ผู้แต่ง ${news.phone}".text.make(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
