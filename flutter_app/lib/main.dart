import 'package:flutter/material.dart';
import 'package:my_gmr/job/actual.dart';
import 'package:my_gmr/router.dart';
import 'package:my_gmr/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Color backgroundColor = const Color(0xFFEFEFEF);

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
  textTheme: const TextTheme(
    //bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
    //headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyGMR',
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
