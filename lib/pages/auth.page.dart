import 'package:email_validator/email_validator.dart';
import 'package:emergency_call_v2/controllers/main.ctr.dart';
import 'package:emergency_call_v2/pages/camera.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

enum AuthState {
  login,
  registor,
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();

  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();

  final firstnameCtr = TextEditingController();
  final lastnameCtr = TextEditingController();
  final phoneCtr = TextEditingController();

  AuthState authState = AuthState.login;
  bool loading = false;
  bool showPassword = true;

  staff() {
    emailCtr.text = "staff@staff.com";
    passwordCtr.text = "@@admin@@admin@@";
  }

  admin() {
    emailCtr.text = "admin@admin.com";
    passwordCtr.text = "@@admin@@admin@@";
  }

  member() {
    emailCtr.text = "member@member.com";
    passwordCtr.text = "member123";
  }

  @override
  void initState() {
    setState(() {
      emailCtr.text = "admin@admin.com";
      passwordCtr.text = "@@admin@@admin@@";
      firstnameCtr.text = "test1";
      lastnameCtr.text = "test2";
      phoneCtr.text = "098033933";
    });
    super.initState();
  }

  @override
  void dispose() {
    emailCtr.dispose();
    firstnameCtr.dispose();
    passwordCtr.dispose();
    super.dispose();
  }

  void carmera() {
    Get.to(() => const CameraExampleHome());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon/icon.png",
                    width: 330,
                  ),
                  Text(
                    authState == AuthState.login
                        ? "เข้าสู่ระบบ"
                        : "สมัครสมาชิก",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 194, 17, 173),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          admin();
                        },
                        child: "admin".text.make(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          staff();
                        },
                        child: "staff".text.make(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          member();
                        },
                        child: "member".text.make(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: emailCtr,
                    decoration: InputDecoration(
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Email",
                      fillColor: Colors.white70,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Enter a valid email"
                            : null,
                  ),
                  if (authState == AuthState.registor)
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: firstnameCtr,
                          decoration: InputDecoration(
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "ชื่อจริง",
                            fillColor: Colors.white70,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => name != null && name.length < 2
                              ? "ชื่อจริงต้องไม่ต่ำกว่า 2 ตัวอักษร"
                              : null,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: lastnameCtr,
                          decoration: InputDecoration(
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "นามสกุล",
                            fillColor: Colors.white70,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => name != null && name.length < 2
                              ? "นามสกุลต้องไม่ต่ำกว่า 2 ตัวอักษร"
                              : null,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneCtr,
                          decoration: InputDecoration(
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "เบอร์โทรศัพท์",
                            fillColor: Colors.white70,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => name != null && name.length < 2
                              ? "เบอร์โทรศัพท์ไม่ต่ำกว่า 8 ตัวอักษร"
                              : null,
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: passwordCtr,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(!showPassword
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Password",
                      fillColor: Colors.white70,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) =>
                        password != null && password.length < 6
                            ? "Enter min. 6 characters"
                            : null,
                  ),
                  // const SizedBox(height: 30),
                  // if (authState == AuthState.registor)
                  //   IconButton(
                  //     onPressed: () {
                  //       Get.to(
                  //         () => const CameraExampleHome(),
                  //       );
                  //     },
                  //     icon: const Icon(Icons.camera),
                  //   ),
                  const SizedBox(height: 30),
                  if (authState == AuthState.login)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fixedSize: Size(Get.width * 0.9, 50),
                        backgroundColor:
                            const Color.fromARGB(255, 194, 17, 173),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        await mainCtr.login(
                          email: emailCtr.text,
                          password: passwordCtr.text,
                        );

                        setState(() {
                          loading = false;
                        });
                      },
                      child: const Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  if (authState == AuthState.registor)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fixedSize: Size(Get.width * 0.9, 50),
                        backgroundColor:
                            const Color.fromARGB(255, 194, 17, 173),
                      ),
                      onPressed: () async {
                        final isValid = formKey.currentState!.validate();
                        if (!isValid) return;

                        setState(() {
                          loading = true;
                        });

                        mainCtr.register(
                          email: emailCtr.text.trim(),
                          password: passwordCtr.text.trim(),
                          firstname: firstnameCtr.text.trim(),
                          lastname: lastnameCtr.text.trim(),
                          phone: phoneCtr.text.trim(),
                        );

                        setState(() {
                          loading = false;
                        });
                      },
                      child: const Text(
                        "สมัครสมาชิก",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (authState == AuthState.login)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          authState = AuthState.registor;
                        });
                      },
                      child: const Text(
                        "สมัครสมาชิก",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 194, 17, 173),
                        ),
                      ),
                    ),
                  if (authState == AuthState.registor)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          authState = AuthState.login;
                        });
                      },
                      child: const Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 194, 17, 173),
                        ),
                      ),
                    ),
                  if (loading == true) const CircularProgressIndicator(),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      "skip.",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        color: Color.fromARGB(255, 31, 101, 207),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
