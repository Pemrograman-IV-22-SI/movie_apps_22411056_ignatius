import 'package:flutter/material.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  static String routName = '/home-user';

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    return const Text('Ini halaman User');
  }
}
