import 'package:flutter/material.dart';
import 'package:movie_apps/admin/genre/genre.dart';
import 'package:movie_apps/admin/home_admin.dart';
import 'package:movie_apps/auth/login_page.dart';
import 'package:movie_apps/auth/register_page.dart';
import 'package:movie_apps/user/home_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Apps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.routName,
      routes: {
        LoginPage.routName: (context) => const LoginPage(),
        RegisterPage.routName: (context) => const RegisterPage(),
        HomeAdmin.routName: (context) => const HomeAdmin(),
        HomeUser.routName: (context) => const HomeUser(),
        Genre.routName: (context) => const Genre(),
      },
    );
  }
}
