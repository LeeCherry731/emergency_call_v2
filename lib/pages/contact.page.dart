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
      body: Center(
        child: "ContactPage".text.make(),
      ),
    );
  }
}
