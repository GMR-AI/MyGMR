import 'package:flutter/material.dart';
import 'welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Color backgroundColor = Color(0xFFEFEFEF);

void main() async {
  await dotenv.load(fileName: ".env"); // Load .env file
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

ThemeData myTheme = ThemeData(
  primaryColor: Colors.green,
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
    headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGMR',
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: const Welcome(title: 'MyGMR'),
    );
  }
}
