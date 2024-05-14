import 'package:flutter/material.dart';
import 'welcome.dart';

Color backgroundColor = Color(0xFFEFEFEF);

void main() {
  runApp(const MyApp());
}

ThemeData myTheme = ThemeData(
  primaryColor: Colors.green, // Color principal de la aplicación
  //fontFamily: 'Roboto', // Fuente predeterminada para el texto
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16.0, color: Colors.black), // Estilo para el texto del cuerpo
    headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold), // Estilo para los encabezados
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  useMaterial3: true,
  // Más configuraciones de tema aquí...
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGMR',
      theme: myTheme,
      debugShowCheckedModeBanner: false, //para quitar la marca de agua
      home: const Welcome(title: 'MyGMR'),
    );
  }
}