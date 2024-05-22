import 'package:flutter/material.dart';
import 'robot_class.dart';
import '../job/configure_grass_height.dart';
import '../job/job_class.dart';
import 'weather.dart';

class Home extends StatelessWidget {
  final Robot robot;

  Home({required this.robot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                robot.img ?? 'assets/robot_design.png',
                fit: BoxFit.cover,
                height: 300.0,
              ),
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
          DefaultTabController(
            length: 3, // número de pestañas actualizado a 3
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Weather'), // Nueva pestaña "Weather"
                      Tab(text: 'Jobs'), // Pestaña "Jobs"
                      Tab(text: 'Settings'), // Pestaña "Settings"
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(child: WeatherWidget()),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
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
                                    'New',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción para ver el trabajo actual
                                  },
                                  child: Text(
                                    'Actual',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción para ver trabajos anteriores
                                  },
                                  child: Text(
                                    'Previous',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción para ir a la información del usuario
                                  },
                                  child: Text(
                                    'Info',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción para editar el usuario
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
