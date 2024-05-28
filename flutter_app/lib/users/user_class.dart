class MyUser {
  int id;
  String? name;
  String? imagePath;
  String? mail;

  MyUser({
    required this.id,
    this.name,
    this.imagePath,
    this.mail,
  });

  factory MyUser.fromJson(Map<String, dynamic> data) {
    return MyUser(
      id: data['id'],
      name: data['name'],
      imagePath: data['path_image'],
      mail: data['mail'],
    );
  }
}

MyUser getUser() {
  return MyUser(
    id: 1,
    name: 'John Doe',
    imagePath: 'assets/perrito.jpg',
    mail: 'johndoe@example.com',
  );
}