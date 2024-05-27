import 'package:flutter/material.dart';
import 'package:my_gmr/job/actual.dart';
import 'robot_class.dart';
import '../job/configure_grass_height.dart';
import '../job/job_class.dart';
import 'weather.dart';
import '../globals.dart'; // Import globals.dart to access globalRobot

class Home extends StatelessWidget {
  Home();

  @override
  Widget build(BuildContext context) {
    Robot? robot = globalRobot; // Get the robot from the global variable

    if (robot == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Home'),
        ),
        body: Center(
          child: Text('No robot available'),
        ),
      );
    }

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
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Weather'),
                      Tab(text: 'Jobs'),
                      Tab(text: 'Settings'),
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
                                    globalJob = Job(
                                      startDate: DateTime.now(),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConfigureGrassHeightPage(),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActualJobPage(),
                                      ),
                                    );
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
