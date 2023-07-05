class Category {
  int? id;
  String? name;
  String? icon;

  Category({this.id, this.name, this.icon});

  // Convert json data to Category model
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}
