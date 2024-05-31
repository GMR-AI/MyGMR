import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'actual.dart';
import 'package:my_gmr/main.dart';
Color backgroundColor = Color(0xFFEFEFEF);

class ModelView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This line removes the debug banner
      title: '3D Model Viewer',
      theme: myTheme,
      home: _ModelView(),
    );
  }
}

class _ModelView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Model Viewer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ActualJobPage()),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.green, Colors.white],
          ),
        ),
        child: const Center(
          child: ModelViewer(
            src: 'assets/gmr.glb',
            alt: "A 3D model of something",
            ar: true,
            autoRotate: true,
            cameraControls: true,
          ),
        ),
      ),
    );
  }
}