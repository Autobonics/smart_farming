class Soil {
  final String id;
  final String about;
  final String chara;
  final String crops;
  final String found;
  final String img;
  final String name;

  Soil({
    required this.id,
    required this.about,
    required this.chara,
    required this.crops,
    required this.found,
    required this.img,
    required this.name,
  });

  factory Soil.fromMap(String id, Map<String, dynamic> data) {
    return Soil(
      id: id,
      about: data['about'] ?? '',
      chara: data['chara'] ?? '',
      crops: data['crops'] ?? "",
      found: data['found in'] ?? '',
      img: data['img'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
