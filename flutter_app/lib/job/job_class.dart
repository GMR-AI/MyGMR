import 'package:flutter/material.dart';

class Job {
  int? id;
  int? id_robot;
  double? cutting_height;
  List<Offset>? area;
  String? model;
  String? state;
  final DateTime start_time;
  DateTime? end_time;
  String? glb_url;
  String? top_image;

  Job({
    this.id,
    this.id_robot,
    this.cutting_height,
    this.area,
    this.model,
    this.state,
    required this.start_time,
    this.end_time,
  });

  // Factory constructor to create a Job instance from a JSON map
  factory Job.fromJson(Map<String, dynamic> data) {
    return Job(
      id: data['id'],
      id_robot: data['id_robot'],
      cutting_height: (data['cutting_height'] as num?)?.toDouble(),
      area: (data['area'] as List<dynamic>?)
          ?.map((e) => Offset(e['x'], e['y']))
          .toList(),
      model: data['model'],
      state: data['state'],
      start_time: DateTime.parse(data['start_time']),
      end_time: data['end_time'] != null ? DateTime.parse(data['end_time']) : null,
    );
  }

  // Method to convert a Job instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_robot': id_robot,
      'cutting_height': cutting_height,
      'area': area?.map((e) => {'x': e.dx, 'y': e.dy}).toList(),
      'model': model,
      'state': state,
      'start_time': start_time.toIso8601String(),
      'end_time': end_time?.toIso8601String(),
    };
  }
}