class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password; // note: in production, hash passwords

  UserModel({this.id, required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email, 'password': password};

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
