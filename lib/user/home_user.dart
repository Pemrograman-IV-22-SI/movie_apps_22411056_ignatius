import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/auth/login_page.dart';
import 'package:movie_apps/user/beli_movie.dart';
import 'package:movie_apps/user/transaksi.dart';
import 'package:toastification/toastification.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  static String routName = '/home-user';

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  bool isLoading = false;
  var dataMovie = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 58, 127, 183),
          title: Row(
            children: [
              const Text('Movie Apps', style: TextStyle(color: Colors.white))
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, TransaksiUser.routeName,
                      arguments: args);
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                )),
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.routName);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        backgroundColor: Color.fromARGB(255, 204, 221, 244),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: dataMovie.length,
                itemBuilder: (context, index) {
                  final movie = dataMovie[index];
                  return Card(
                    color: Colors.grey[850],
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Film
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl + movie['image'],
                              width: 80,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey,
                                  child:
                                      const Icon(Icons.broken_image, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Detail Film
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Judul Film
                                Text(
                                  movie['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Genre
                                Text(
                                  "Genre: ${movie['genre_movie_genreTogenre']['name']}",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Rating dengan Bintang
                                Row(
                                  children: List.generate(
                                    5,
                                    (starIndex) => Icon(
                                      Icons.star,
                                      size: 16,
                                      color: starIndex < movie['rating'].toInt()
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  )..add(
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          movie['rating'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Rp. ${movie['price']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                // Deskripsi Film
                                Text(
                                  movie['description'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Beli',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, BeliMovie.routeName,
                                              arguments: {
                                                "movie": movie,
                                                "user": args
                                              });
                                        },
                                        icon: const Icon(Icons.shopping_bag,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.get(getAllMovie);
      if (response.data['status'] == true) {
        dataMovie = response.data['data'];
        print(dataMovie);
      } else {
        dataMovie = [];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Server Tidak Merespone'),
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
