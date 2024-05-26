import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> push_and_get_robots(context, code) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['BACKEND_URL']}/robot_request'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'code': code!,
    }),
  );
  final data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return data;
  } else {
    print('Failed to add robot');
    return data['message'];
  }

}