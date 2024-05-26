import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_gmr/robots/robot_class.dart';
import 'robots/no_robots.dart';
import 'robots/list_of_robots.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Create storage
final storage = new FlutterSecureStorage();

// "Automatic Login"
Future<void> checkAuthentication(context) async {

  String? token = await storage.read(key: 'userToken');
  if (token != null) {
      authenticate(context, token);
  }
}

// General auth function
Future<void> authenticate(context, idToken) async {
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
    // TODO: Preprocess data
    robot_list = data;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListOfRobots()),
    );

  } else {
    print('Failed to authenticate with Flask backend');
    await storage.delete(key: 'userToken');
  }

}

Future<User?> signInWithGoogle(context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // The user canceled the sign-in
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    if (user != null) {
      // Send the ID token to your Flask backend
      final String? idToken = await user.getIdToken();
      authenticate(context, idToken);
      // Everything went well
      await storage.write(key: 'userToken', value: idToken);
    }
  } catch (e) {
    print(e); // Handle error
    return null;
  }
}