class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;

  UserModel({this.id, required this.name, required this.email, required this.password});

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as int?,
        name: m['name'] ?? '',
        email: m['email'] ?? '',
        password: m['password'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };
}
