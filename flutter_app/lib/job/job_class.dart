import 'package:flutter/material.dart';

class Job {
  int? id;
  final int id_robot;
  int? cutting_height;
  Map<String, dynamic>? area;
  DateTime? start_time;
  DateTime? end_time;
  String? glb_url;
  String? top_image;

  Job({
    this.id,
    required this.id_robot,
    this.cutting_height,
    this.area,
    this.start_time,
    this.end_time,
  });

  // Factory constructor to create a Job instance from a JSON map
  factory Job.fromJson(Map<String, dynamic> data) {
    return Job(
      id: data['id'],
      id_robot: data['id_robot'],
      cutting_height: data['cutting_height'],
      area: data['area'],
      start_time: DateTime.parse(data['start_time']),
      end_time: (data['end_time'] == null) ? null : DateTime.parse(data['end_time']),
    );
  }

  // Method to convert a Job instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_robot': id_robot,
      'cutting_height': cutting_height,
      'area': area,
      'start_time': start_time,
      'end_time': end_time,
    };
  }
}