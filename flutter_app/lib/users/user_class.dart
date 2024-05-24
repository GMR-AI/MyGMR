class User {
  int id;
  String? name;
  String? imagePath;
  String? mail;
  final String? idToken;

  User({
    required this.id,
    this.name,
    this.imagePath,
    this.mail,
    this.idToken,
  });
}

User getUser() {
  return User(
    id: 1,
    name: 'John Doe',
    imagePath: 'assets/perrito.jpg',
    mail: 'johndoe@example.com',
  );
}