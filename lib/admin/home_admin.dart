import 'package:flutter/material.dart';
import 'package:movie_apps/admin/genre/genre.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  static String routName = '/home-admin';

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 58, 127, 183),
          title: const Row(
            children: [
              Icon(Icons.home, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                "Movie Apps",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Color.fromARGB(255, 204, 221, 244),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 80,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 1, 39, 82),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, Genre.routName),
                          child: const Column(
                            children: [
                              Icon(Icons.movie_creation_outlined,
                                  size: 32.0, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Genre',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 100,
                        height: 80,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2f2f2f),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: GestureDetector(
                          // //onTap: () =>
                          //     Navigator.pushNamed(context, Page2.routes),
                          child: const Column(
                            children: [
                              Icon(Icons.movie,
                                  size: 32.0, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Movie',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 80,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2f2f2f),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: GestureDetector(
                          // onTap: () =>
                          //     Navigator.pushNamed(context, Page3.routes),
                          child: const Column(
                            children: [
                              Icon(Icons.receipt,
                                  size: 32.0, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Transaksi',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 100,
                        height: 80,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 1, 39, 82),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: GestureDetector(
                          // onTap: () =>
                          //     Navigator.pushNamed(context, Page4.routes),
                          child: const Column(
                            children: [
                              Icon(Icons.exit_to_app,
                                  size: 32.0, color: Colors.white),
                              SizedBox(height: 4),
                              Text('Logout',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
