import 'package:flutter/material.dart';
import 'robots/robot_class.dart';
import 'user_profile.dart';
import 'job/configure_grass_height.dart';
import 'job/job_class.dart';

class Home extends StatelessWidget {
  final Robot robot;

  Home({required this.robot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Aquí va la imagen del robot
          Stack(
            children: [
              // Imagen del robot
              Image.asset(
                robot.imagePath,
                fit: BoxFit.cover,
                height: 300.0, // Tamaño de la imagen
              ),
              // Texto en la esquina inferior izquierda
              Positioned(
                bottom: 8.0,
                left: 8.0,
                child: Text(
                  '${robot.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'Logo',
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Create an instance of Job
                  Job newJob = Job(
                    date: DateTime.now(),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigureGrassHeightPage(job: newJob),
                    ),
                  );
                },
                child: Text(
                    'New job',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(300, 50)
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Acción para el botón New Job
                },
                child: Text(
                  'See previous works',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(300, 50)
                ),
              ),
            ],
          ),
          // Barra de opciones
          BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfile()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
