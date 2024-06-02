import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_gmr/robots/robot_class.dart';
import '../globals.dart' as globals;

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
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> robotsData = data["robots"];
    List<Robot> robots = robotsData.map((robotData) => Robot.fromJson(robotData)).toList();
    return robots;
  } else {
    return [];
  }
}

Future<Map<String, dynamic>?> getModel() async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/get_robot_info'),
    headers: <String, String>{
      'Cookie': globals.sessionID ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'code': globals.globalRobot!.id_model!,
    }),
  );

  return jsonDecode(response.body);
}

Future<void> delete_this_robot(int robotId, int robotCode) async {
  await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/delete_robot'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': globals.sessionID ?? '',
    },
    body: jsonEncode(<String, int>{'robot_id': robotId, 'code': robotCode}),
  );
}






