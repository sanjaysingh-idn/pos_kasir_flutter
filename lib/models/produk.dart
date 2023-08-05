import 'package:pos_kasir/models/category.dart';

class Produk {
  int id;
  String name;
  Category? category;
  String desc;
  dynamic image;
  int priceBuy;
  int priceSell;
  int stock;
  DateTime createdAt;
  DateTime updatedAt;

  Produk({
    required this.id,
    required this.name,
    required this.category,
    required this.desc,
    this.image,
    required this.priceBuy,
    required this.priceSell,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Produk.fromJson(Map<String, dynamic> json) => Produk(
        id: json["id"],
        name: json["name"],
        category: json["category"] != null
            ? Category.fromJson(json["category"])
            : null,
        desc: json["desc"],
        image: json["image"],
        priceBuy: json["priceBuy"],
        priceSell: json["priceSell"],
        stock: json["stock"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category!.toJson(),
        "desc": desc,
        "image": image,
        "priceBuy": priceBuy,
        "priceSell": priceSell,
        "stock": stock,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

List<Produk> parseProductList(dynamic responseData) {
  if (responseData is List) {
    return responseData.map((json) => Produk.fromJson(json)).toList();
  } else {
    return [];
  }
}
