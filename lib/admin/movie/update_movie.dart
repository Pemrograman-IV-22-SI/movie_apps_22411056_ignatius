import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_apps/admin/model/genre_model.dart';
import 'package:movie_apps/admin/movie/movie.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:toastification/toastification.dart';

class UpdateMoviePage extends StatefulWidget {
  const UpdateMoviePage({super.key});
  static String routeName = '/update-movie';
  @override
  State<UpdateMoviePage> createState() => _UpdateMoviePageState();
}

class _UpdateMoviePageState extends State<UpdateMoviePage> {
  final dio = Dio();
  bool isLoading = false;
  int? id_genre;
  String? genre;
  int? id_movie;

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GenreModel? _selectedGenre;

  Future<List<GenreModel>> getData() async {
    try {
      var response = await Dio().get(getAllGenre);
      final data = response.data["data"];
      if (data != null) {
        return GenreModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });
      }
    } catch (e) {
      throw Exception("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    int idMovie = args["id_movie"];
    String title = args["title"];
    String price = args["price"].toString();
    String rating = args["rating"].toString();
    String description = args["description"];
    genre = args["genre_movie_genreTogenre"]["name"].toString();
    _selectedGenre =
        _selectedGenre ?? GenreModel.fromJson(args["genre_movie_genreTogenre"]);

    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        ratingController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      titleController.text = title;
      priceController.text = price;
      ratingController.text = rating;
      descriptionController.text = description;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF232429),
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
            const Text("Form Edit Movie",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: priceController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: ratingController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                labelText: "Rating",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownSearch<GenreModel>(
              popupProps: PopupProps.dialog(
                itemBuilder:
                    (BuildContext context, GenreModel item, bool isDisabled) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListTile(
                      title: Text(item.name),
                      leading: CircleAvatar(child: Text(item.name[0])),
                    ),
                  );
                },
                showSearchBox: true,
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: "Search Genre...",
                  ),
                ),
              ),
              asyncItems: (String? filter) => getData(),
              itemAsString: (GenreModel? item) => item?.userAsString() ?? "",
              onChanged: (GenreModel? data) {
                setState(() {
                  _selectedGenre = data;
                  id_genre = data?.id_genre;
                });
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select Genre",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              selectedItem: _selectedGenre,
              dropdownBuilder:
                  (BuildContext context, GenreModel? selectedItem) {
                var text = _selectedGenre == null
                    ? genre.toString()
                    : _selectedGenre!.name;
                return Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white, // Warna teks yang dipilih
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                pickImage();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50)),
              child: const Text("Pilih Gambar",
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 16,
            ),
            _imageBytes != null
                ? Image.memory(
                    _imageBytes!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : Image.network("$imageUrl${args['image']}",
                    width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(
              height: 32,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      updateMovieResponse(idMovie);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        minimumSize: const Size.fromHeight(50)),
                    child: const Text(
                      "Edit Movie",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ))),
    );
  }

  void updateMovieResponse(idMovie) async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      var imgData = _imageBytes != null
          ? MultipartFile.fromBytes(_imageBytes!, filename: 'image.jpg')
          : null;

      FormData formData = FormData.fromMap({
        "image": imgData,
        "title": titleController.text,
        "price": priceController.text,
        "rating": ratingController.text,
        "description": descriptionController.text,
        "genre": _selectedGenre?.id_genre,
      });

      Response response;

      response = await dio.put("$editMovie$idMovie", data: formData);

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['msg']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushNamed(context, MoviePage.routeName);
      } else {
        toastification.show(
            title: Text(response.data['msg']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      print(e);
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
