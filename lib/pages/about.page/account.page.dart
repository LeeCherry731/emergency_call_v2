import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "ข้อมูลส่วนตัว".text.minFontSize(18).make(),
      ),
    );
  }
}
