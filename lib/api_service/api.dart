String baseUrl = "http://192.168.143.233:3000";

String register = "$baseUrl/user/register";
String login = "$baseUrl/user/login";

//image
String imageUrl = "$baseUrl/img/movie/";

//genre
String getAllGenre = "$baseUrl/genre/get";
String insertGenre = "$baseUrl/genre/insert";
String hapusGenre = "$baseUrl/genre/delete/";
String editGenre = "$baseUrl/genre/edit/";

// movie
String getAllMovie = "$baseUrl/movie/get-all";
String hapusMovie = "$baseUrl/movie/delete/";
String inputMovie = "$baseUrl/movie/insert";
String editMovie = "$baseUrl/movie/edit/";

//transaksi
String insertTransaksi = "$baseUrl/transaction/insert";
String getTransaksi = "$baseUrl/transaction/get-all";
String getTransaksiId = "$baseUrl/transaction/get/";
String confirmTranskasi = "$baseUrl/transaction/confirm-transaction/";
