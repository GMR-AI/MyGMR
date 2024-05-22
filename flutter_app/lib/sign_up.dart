import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'robots/no_robots.dart';
import 'robots/list_of_robots.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Color backgroundColor = Color(0xFFEFEFEF);

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
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
          final List<dynamic> robots = data['robots'];

          if (robots.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListOfRobots()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoRobots()),
            );
          }
        } else {
          print('Failed to authenticate with Flask backend');
        }
      }

    } catch (e) {
      print(e); // Handle error
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    topRight: Radius.circular(100.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, -3), // Cambia el signo para mover la sombra hacia arriba
                    ),
                  ],
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      User? user = await _signInWithGoogle();
                      if (user != null) {
                        print('Successfully signed in with Google: ${user.displayName}');
                        // Navigate to another screen or do something else
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      foregroundColor: Colors.black, // Text color
                      minimumSize: Size(double.infinity, 50), // Button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google_logo.png',
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Sign In with Google',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoRobots()),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontFamily: 'Normal',
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
