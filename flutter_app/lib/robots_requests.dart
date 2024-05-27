import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_gmr/robots/robot_class.dart';
import 'globals.dart' as globals;

Future<bool> push_robot(code) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/robot_request'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'code': code!,
    }),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    final data = jsonDecode(response.body);
    print(data['message']);
    return false;
  }
}

Future<List<Robot>?> get_robots() async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/get_robots'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    print(response.body);
    // Generate list of robots here
    return data.map((robotData) => Robot.fromJson(robotData)).toList();
  } else {
    print('Failed to get robots');
    return [];
  }
}

Future<String> fetchRobotImage(String imageName) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/get_image'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'image_name': imageName,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['image_url'];
  } else {
    throw Exception('Failed to load robot image URL');
  }
}