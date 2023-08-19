import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: "NewsPage".text.make(),
      ),
    );
  }
}
