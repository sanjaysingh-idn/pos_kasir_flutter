class Category {
  int? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  // Convert json data to Category model
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
