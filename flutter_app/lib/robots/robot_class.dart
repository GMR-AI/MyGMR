import 'package:my_gmr/functions/robots_requests.dart';

class Robot {
  final int id;
  int? id_connect;
  String? name;
  final String? img;
  int? id_active_job;
  int? id_user;
  int? id_model;
  String? reconstruction_path;
  bool status;

  Robot({
    required this.id,
    this.id_connect,
    this.name,
    this.img,
    this.id_active_job,
    this.id_user,
    this.id_model,
    this.reconstruction_path,
    required this.status
  });

  // Factory constructor to create a Robot instance from a JSON map
  factory Robot.fromJson(Map<String, dynamic> data) {
    return Robot(
      id: data['id'],
      id_connect: data['id_connect'],
      name: data['name'],
      img: data["img"],
      id_active_job: data['id_active_job'],
      id_user: data['id_user'],
      id_model: data['id_model'],
      reconstruction_path: data['reconstruction_path'],
      status: data['status'],
    );
  }
}