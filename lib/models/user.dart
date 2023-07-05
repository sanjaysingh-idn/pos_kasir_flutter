class User {
  int? id;
  String? name;
  String? role;
  String? image;
  String? email;
  String? token;

  User({this.id, this.name, this.role, this.image, this.email, this.token});

  // Convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      role: json['user']['role'],
      image: json['user']['image'],
      email: json['user']['email'],
      token: json['token'],
    );
  }
}
