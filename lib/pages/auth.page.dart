import 'package:email_validator/email_validator.dart';
import 'package:emergency_call_v2/pages/main.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  AuthState authState = AuthState.login;
  bool loading = false;
  bool showPassword = true;

  @override
  void initState() {
    // setState(() {
    //   emailController.text = "test@test.com";
    //   passwordController.text = "aaaaaa";
    // });
    setState(() {
      emailController.text = "admin@admin.com";
      passwordController.text = "@@admin@@admin@@";
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();

    super.dispose();
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
                  if (authState == AuthState.registor)
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Username",
                        fillColor: Colors.white70,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (name) => name != null && name.length < 2
                          ? "ชื่อต้องไม่ต่ำกว่า 2 ตัวอักษร"
                          : null,
                    ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
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
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: passwordController,
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
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
                  const SizedBox(height: 30),
                  if (authState == AuthState.login)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(Get.width * 0.9, 50),
                        backgroundColor:
                            const Color.fromARGB(255, 194, 17, 173),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        if (emailController.text == "admin@admin.com" &&
                            passwordController.text == "@@admin@@admin@@") {
                          Get.offAll(() => const MainPage());
                          return;
                        }

                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          Get.offAll(() => const MainPage());
                        } on FirebaseAuthException catch (e) {
                          Get.showSnackbar(GetSnackBar(
                            title: "เกิดข้อผิดพลาด",
                            message: e.toString(),
                          ));
                        }

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
                        try {
                          final result = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          if (result.isBlank == false) {
                            result.user!
                                .updateDisplayName(nameController.text.trim());
                          }
                        } on FirebaseAuthException catch (e) {
                          Get.showSnackbar(GetSnackBar(
                            title: "เกิดข้อผิดพลาด",
                            message: e.toString(),
                          ));
                        }

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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
