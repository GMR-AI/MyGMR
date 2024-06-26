import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_gmr/users/user_class.dart';

import '../globals.dart' as globals;

void setSessionID(String? sessionID) {
  globals.sessionID = sessionID;
}

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
Future<void> authenticate(BuildContext context, idToken) async {
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
    // Assume `response` is the response object received from the server
    setSessionID(response.headers['set-cookie']);
    globals.globalUser = MyUser.fromJson(jsonDecode(response.body));
    if (context.mounted) {

      context.goNamed("list_robots");
    }
  } else {
    await storage.delete(key: 'userToken');
  }
}

Future<void> signInWithGoogle(context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return;
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
    // Handle specific exceptions
    if (e is FirebaseAuthException) {
      print('Firebase Auth Error: ${e.message}');
    } else if (e is GoogleSignInAuthentication) {
      print('Google Sign-In Error: ${e.toString()}');
    } else {
      print('Error: $e');
    }
  }
}

