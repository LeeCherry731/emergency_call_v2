import 'package:emergency_call_v2/models/enum.dart';

class UserModel {
  String id = "";
  String firstname = "สวัสดี";
  String lastname = "";
  Role role = Role.none;
  String email = "";
  String phone = "";
  String locations = "";
  String picture = "";
  String createdAt = "";
  String updatedAt = "";

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final UserModel u = UserModel();
    u.id = json["id"];
    u.firstname = json["firstname"];
    u.lastname = json["lastname"];
    u.role = stringToRole(json["role"]);
    u.email = json["email"];
    u.phone = json["phone"];
    u.picture = json["picture"];
    u.createdAt = json["createdAt"];
    u.updatedAt = json["updatedAt"];
    return u;
  }
}
