import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_apps/admin/model/genre_model.dart';
import 'package:movie_apps/api_service/api.dart';

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

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController ratingcontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  GenreModel? _selectedGenre;

  Future<List<GenreModel>> getData() async {
    try {
      var response = await Dio().get(getAllGenre);
      final data = response.data["data"];
      if (data != null) {
        return GenreModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
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

    titlecontroller.text = args['title'];
    pricecontroller.text = args['price'].toString();
    ratingcontroller.text = args['rating'].toString();
    descriptioncontroller.text = args['description'];
    genre = args['genre_movie_genreTogenre']['name'].toString();
    id_genre = args['genre_movie_genreTogenre']['id_genre'];

    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Form Edit Movie !",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: titlecontroller,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: pricecontroller,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: descriptioncontroller,
                decoration: const InputDecoration(
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
                controller: ratingcontroller,
                decoration: const InputDecoration(
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
                      color: Colors.black, // Warna teks yang dipilih
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
                child: const Text(
                  "Pilih Gambar",
                  style: TextStyle(color: Colors.white),
                ),
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
                  : Image.network("$imageUrl/${args['image']}",
                      width: 200, height: 200, fit: BoxFit.cover),
              const SizedBox(
                height: 32,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        inputMovieResponse();
                        // if (genrecontroller.text.isEmpty && genrecontroller.text == '') {
                        //   toastification.show(
                        //       context: context,
                        //       title: const Text("Username Tidak Boleh Kosong!"),
                        //       type: ToastificationType.error,
                        //       autoCloseDuration: const Duration(seconds: 3),
                        //       style: ToastificationStyle.fillColored);
                        // } else {
                        //   inputResponse();
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Edit Movie",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      )),
    );
  }

  void inputMovieResponse() {}
}
