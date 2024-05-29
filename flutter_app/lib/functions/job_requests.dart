import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../globals.dart' as globals;
import '../job/job_class.dart';
import 'package:flutter/material.dart';
import '../job/configure_grass_height.dart';

Future<List<Job>?> get_list_of_jobs(int rid) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/get_all_jobs'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{'rid': rid}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey('message') && data['message'] == "All jobs getted") {
      final List<dynamic> jobsData = data['jobs'];
      List<Job> jobs = jobsData.map((jobData) => Job.fromJson(jobData)).toList();
      return jobs;
    } else {
      print('No jobs available');
      return null;
    }
  } else {
    print('Failed to get jobs');
    return null;
  }
}

Future<int?> add_job(Job job) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/add_new_job'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(jsonEncode({
      ...job.toJson(),
      'code': globals.globalRobot!.id_connect!,
    }),),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final jobID = data['job_id'] as int?;
    if (jobID != null) {
      print('Job added successfully with ID: $jobID');
      return jobID;
    } else {
      print('Failed to get job ID');
      return null;
    }
  } else {
    print('Failed to add job');
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return null;
  }
}

Future<void> delete_jobs(int rid) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/delete_jobs'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{'rid': rid}),
  );

  if (response.statusCode == 200) {
    print('All jobs already deleted');
  } else {
    print('Failed to delete jobs');
  }
}

Future<Job?> get_active_job(int robotId) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/get_active_job'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': globals.sessionID ?? '',
    },
    body: jsonEncode(<String, int>{'robot_id': robotId}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final jobData = data['job'];
    if (jobData != null) {
      final job = Job.fromJson(jobData);
      print('Active job found: $job');
      return job;
    } else {
      print('No active job found');
      return null;
    }
  } else {
    print('Failed to get active job');
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return null;
  }
}

Future<void> finish_active_job(int robotId) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/finish_active_job'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': globals.sessionID ?? '',
    },
    body: jsonEncode(<String, int>{'robot_id': robotId}),
  );

  if (response.statusCode == 200) {
    print('Active job finished successfully');
  } else {
    print('Failed to finish active job');
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

Future<void> checkServerResponse(context) async {
  final response = await http.get(
    Uri.parse('${dotenv.env['BACKEND_URL']}/check_status'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'desired_code') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConfigureGrassHeightPage(),
        ),
      );
    }
  }
}
