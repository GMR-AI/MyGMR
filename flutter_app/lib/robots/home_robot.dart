import 'package:flutter/material.dart';
import 'package:my_gmr/job/actual.dart';
import 'robot_class.dart';
import '../job/configure_grass_height.dart';
import '../job/job_class.dart';
import 'weather.dart';
import 'dart:async';
import '../globals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../functions/robots_requests.dart';
import '../functions/job_requests.dart';
import '../job/list_of_jobs.dart';
import 'info_model.dart';


class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home>  {
  //Home();
  bool _isLoading = false;

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
              CachedNetworkImage(
                imageUrl: robot.img ?? '',
                fit: BoxFit.cover,
                height: 300.0,
                errorWidget: (context, error, stackTrace) =>
                    Image.asset(
                      'assets/robot_design.png',
                      fit: BoxFit.cover,
                      height: 300.0,
                    ),
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
                        child: _isLoading
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 40), // Add some spacing between the CircularProgressIndicator and the text
                                    Text(
                                      'Wait a minute, the reconstruction is being processed',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              )
                            : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    globalJob = Job(
                                      id_robot: robot.id,
                                    );
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    // Update the robot status
                                    request_new_job(context);
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
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActualJobPage(),
                                      ),
                                    );
                                    // Job? actualJob = await get_active_job(robot.id);
                                    // if (actualJob != null) {
                                    //   robot.id_active_job = actualJob.id;
                                    //   globalRobot = robot;
                                    //   globalJob = actualJob;
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => ActualJobPage(),
                                    //     ),
                                    //   );
                                    // } else {
                                    //   globalJob = null;
                                    //   robot.id_active_job = null;
                                    //   globalRobot = robot;
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => ActualJobPage(),
                                    //     ),
                                    //   );
                                    // }
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
                                  onPressed: () async {
                                    int rid = robot.id;
                                    List<Job>? jobs = await get_list_of_jobs(rid);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListOfJobs(jobs: jobs ?? []),
                                      ),
                                    );
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
                                    // Navigate to the new page
                                    getModel();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ModelInfoScreen()),
                                    );
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
