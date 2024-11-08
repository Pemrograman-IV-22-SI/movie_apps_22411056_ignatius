import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/admin/home_admin.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:toastification/toastification.dart';

class Genre extends StatefulWidget {
  const Genre({super.key});
  static String routName = '/genre';
  @override
  State<Genre> createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  final dio = Dio();
  bool isLoading = false;
  var dataGenre = [];

  @override
  void initState() {
    // TODO: implement initState

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 58, 127, 183),
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeAdmin.routName);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const Text('Genre', style: TextStyle(color: Colors.white))
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: Color.fromARGB(255, 204, 221, 244),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                var genre = dataGenre[index];
                return ListTile(
                  title: Text(
                    genre['name'],
                    style:
                        const TextStyle(color: Color.fromARGB(255, 2, 18, 70)),
                  ),
                  leading: const Icon(
                    Icons.movie,
                    color: Color.fromARGB(255, 2, 18, 70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 131, 100, 8),
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 99, 11, 3),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: dataGenre.length,
            ),
    );
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.get(getAllGenre);
      if (response.data['status'] == true) {
        dataGenre = response.data['data'];
      } else {
        dataGenre = [];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Server tidak meresponse'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
