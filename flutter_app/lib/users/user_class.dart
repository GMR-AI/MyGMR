class User {
  int id;
  String? name;
  String? imagePath;
  String? mail;

  User({
    required this.id,
    this.name,
    this.imagePath,
    this.mail,
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