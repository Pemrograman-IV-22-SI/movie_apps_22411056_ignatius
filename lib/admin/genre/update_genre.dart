import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/admin/genre/genre.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:toastification/toastification.dart';

class UpdateGenre extends StatefulWidget {
  const UpdateGenre({super.key});
  static const routeName = '/edit_genre';

  @override
  State<UpdateGenre> createState() => _InputGenreState();
}

class _InputGenreState extends State<UpdateGenre> {
  final dio = Dio();

  bool isloading = false;

  TextEditingController genreController = TextEditingController();
  String name = " ";
  int? id_genre;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    name = args['name'];
    id_genre = args['id_genre'];
    genreController.text = name;
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            const Text(
              "Edit Genre",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: genreController,
              decoration: const InputDecoration(
                labelText: "Nama Genre",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            isloading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (genreController.text.isEmpty &&
                          genreController.text == '') {
                        toastification.show(
                            context: context,
                            title: const Text("Genre tidak boleh kosong"),
                            autoCloseDuration: const Duration(seconds: 3),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored);
                      } else {
                        updateGenreResponse(id_genre!, genreController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      "Edit Genre",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ))),
    );
  }

  void updateGenreResponse(int id_genre, name) async {
    try {
      print(editGenre + id_genre.toString());
      setState(() {
        isloading = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      Response response;
      response = await dio.put(editGenre + id_genre.toString(), data: {
        "name": name,
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, Genre.routName);
      } else {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
      ;
    } catch (e) {
      toastification.show(
          context: context,
          title: Text("Terjadi Kesalahan pada Server"),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
