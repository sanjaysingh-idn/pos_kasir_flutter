class Produk {
  int? id;
  String? name;
  int? category;
  String? desc;
  String? image;
  int? priceBuy;
  int? priceSell;
  int? stock;
  String? barcode;

  Produk({
    this.id,
    this.name,
    this.category,
    this.desc,
    this.image,
    this.barcode,
    this.priceBuy,
    this.priceSell,
    this.stock,
  });

  // Convert json data to Produk model
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      desc: json['desc'],
      image: json['image'],
      barcode: json['barcode'],
      priceBuy: json['priceBuy'],
      priceSell: json['priceSell'],
      stock: json['stock'],
    );
  }
}
