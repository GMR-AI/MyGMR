class Robot {
  final int id;
  String? id_connect;
  String? name;
  final String? img;
  int? id_active_job;
  int? id_user;

  Robot({
    required this.id,
    this.id_connect,
    this.name,
    this.img,
    this.id_active_job,
    this.id_user,
  });
}