import 'package:flutter/material.dart';

class LocationDoc {
  final String id;
  final double latitude;
  final double longitude;
  final String email;
  final String name;
  final String title;
  final String phone;
  final String status;
  final String picture;
  final String createdAt;

  LocationDoc({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.email,
    required this.name,
    required this.title,
    required this.phone,
    required this.status,
    required this.picture,
    required this.createdAt,
  });

  String getDate() {
    final date = DateTime.parse(createdAt);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}";
  }

  String getStatus() {
    String data = "รอความช่วยเหลือ";

    switch (status) {
      case "waiting":
        data = "รอความช่วยเหลือ";
        break;
      case "going":
        data = "เจ้าหน้าที่กำลังไป";
        break;
      case "success":
        data = "ช่วยเหลือสำเร็จ";
        break;
      case "failed":
        data = "ช่วยเหลือล้มเหลว";
        break;
      default:
        break;
    }

    return data;
  }

  Color getColor() {
    Color data = Colors.red;

    switch (status) {
      case "waiting":
        data = const Color.fromARGB(255, 227, 204, 0);
        break;
      case "going":
        data = Colors.orange;
        break;
      case "success":
        data = Colors.green;
        break;
      case "failed":
        data = Colors.red;
        break;
      default:
        break;
    }

    return data;
  }
}
