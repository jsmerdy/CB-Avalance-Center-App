class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': 0,
      'name': name,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }
}