import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../job/list_of_jobs.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> get_list_of_jobs(context, idToken) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/g_auth'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'idToken': idToken!,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> jobs = data['jobs'];

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListOfJobs(jobs: jobs)),
    );
  } else {
    print('Failed to get jobs list');
  }
}
