import 'package:my_gmr/functions/robots_requests.dart';

class Robot {
  final int id;
  String? id_connect;
  String? name;
  final String? img;
  int? id_active_job;
  int? id_user;
  int? id_model;
  bool status;

  Robot({
    required this.id,
    this.id_connect,
    this.name,
    this.img,
    this.id_active_job,
    this.id_user,
    this.id_model,
    required this.status
  });
  // Factory constructor to create a Robot instance from a JSON map
  factory Robot.fromJson(Map<String, dynamic> data, img) {
    return Robot(
      id: data['id'],
      id_connect: data['id_connect'],
      name: data['name'],
      img: img,
      id_active_job: data['id_active_job'],
      id_user: data['id_user'],
      id_model: data['id_model'],
      status: data['status'],
    );
  }
}