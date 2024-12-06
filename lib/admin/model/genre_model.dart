class GenreModel {
  final int id_genre;
  final String name;

  GenreModel({
    required this.id_genre,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id_genre: json["id_genre"],
      name: json["name"],
    );
  }

  static List<GenreModel> fromJsonList(List list) {
    return list.map((item) => GenreModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$id_genre $name';
  }

  /// Check equality of two models
  bool isEqual(GenreModel model) {
    return id_genre == model.id_genre;
  }

  @override
  String toString() => name;
}
