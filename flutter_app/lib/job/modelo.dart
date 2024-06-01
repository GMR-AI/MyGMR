import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

Color backgroundColor = Color(0xFFEFEFEF);

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This line removes the debug banner
      title: '3D Model Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Welcome2('3D Model Viewer'),
    );
  }
}

class Welcome2 extends StatelessWidget {
  // to control the animation
  O3DController controller = O3DController();

  final String title;

  Welcome2(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Cambia el color de la barra de arriba a verde
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () =>
                  controller.cameraOrbit(20, 20, 5),
              icon: const Icon(Icons.change_circle)),
          IconButton(
              onPressed: () =>
                  controller.cameraTarget(1.2, 1, 4),
              icon: const Icon(Icons.change_circle_outlined)),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.white], // Azul que se desvanece en blanco
              ),
            ),
          ),
          O3D.asset(
            src: 'https://storage.googleapis.com/gmr-ai-images/gmr.glb',
            controller: controller,
          ),
        ],
      ),
    );
  }
}
