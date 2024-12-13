import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:movie_apps/user/home_user.dart';
import 'package:toastification/toastification.dart';

class BeliMovie extends StatefulWidget {
  const BeliMovie({super.key});
  static String routeName = '/beli-movie';

  @override
  State<BeliMovie> createState() => _BeliMovieState();
}

class _BeliMovieState extends State<BeliMovie> {
  final dio = Dio();
  bool isLoading = false;
  var total = 0.0;
  String? userId;
  int? movieId;
  var user;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController jumlahBelicontroller = TextEditingController();
  TextEditingController totalcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    titlecontroller.text = args['movie']['title'];
    pricecontroller.text = args['movie']['price'].toString();
    movieId = args['movie']['id_movie'];
    userId = args['user']['username'];
    user = args['user'];

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
                "Beli Movie !",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Image.network("$imageUrl/${args['movie']['image']}",
                  width: 200, height: 200, fit: BoxFit.cover),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: titlecontroller,
                enabled: false,
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
                enabled: false,
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
                controller: jumlahBelicontroller,
                decoration: const InputDecoration(
                  labelText: "Jumlah Beli",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      total = double.parse(pricecontroller.text) *
                          double.parse(value);
                      totalcontroller.text = total.toString();
                    } else {
                      total = 0.0;
                      totalcontroller.text = total.toString();
                    }
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: totalcontroller,
                decoration: const InputDecoration(
                  labelText: "Total",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (jumlahBelicontroller.text.isEmpty &&
                            jumlahBelicontroller.text == '') {
                          toastification.show(
                              context: context,
                              title:
                                  const Text("Jumlah Beli Tidak Boleh Kosong!"),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
                        } else {
                          responseTransaksi();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Beli Movie",
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

  void responseTransaksi() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.post(insertTransaksi, data: {
        "userID": userId,
        "movieID": movieId,
        "harga": pricecontroller.text,
        "jumlah": jumlahBelicontroller.text,
        "total": totalcontroller.text
      });
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, HomeUser.routName, arguments: user);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text('Terjadi Kesalahan pada Server'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
