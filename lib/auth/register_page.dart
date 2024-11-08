// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/auth/login_page.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String routName = "/register-page";
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final dio = Dio();
  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Daftar Akun!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: fullnameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            const SizedBox(
              height: 16,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (usernameController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Username Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            animationDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (fullnameController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Nama Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            animationDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (phoneController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Handphone Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            animationDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (emailController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Email Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            animationDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else if (passwordController.text.isEmpty) {
                        toastification.show(
                            context: context,
                            title: const Text('Password Tidak Boleh Kosong!'),
                            type: ToastificationType.error,
                            animationDuration: const Duration(seconds: 3),
                            style: ToastificationStyle.fillColored);
                      } else {
                        registerResoponse();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Sudah Punya Akun?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routName);
                    },
                    child: const Text('Masuk disini'))
              ],
            )
          ],
        ),
      ))),
    );
  }

  void registerResoponse() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(register, data: {
        "username": usernameController.text,
        "nama": fullnameController.text,
        "email": emailController.text,
        "no_telp": phoneController.text,
        "password": passwordController.text
      });
      if (response.data['status']) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
        Navigator.pushNamed(context, LoginPage.routName);
      } else {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text("Terjadi kesalahan pada server"),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
