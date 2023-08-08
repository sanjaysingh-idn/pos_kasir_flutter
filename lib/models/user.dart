class User {
  int? id;
  String? name;
  String? role;
  String? email;
  String? token;

  User({
    this.id,
    this.name,
    this.role,
    this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['user']['name'],
      role: json['user']['role'],
      email: json['user']['email'],
      token: json['token'],
    );
  }
}
