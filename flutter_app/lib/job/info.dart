import 'package:flutter/material.dart';
import 'package:my_gmr/globals.dart';
class JobInfo extends StatelessWidget {
  final dynamic job;

  JobInfo({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cutting Height: ${job['cutting_height']}'),
            Text('Area: ${job['area']}'),
            Text('Model: ${job['model']}'),
            Text('State: ${globalRobot!.id_active_job == job['id'] ? 'active' : 'finished'}'),
            Text('Start Time: ${job['start_time']}'),
            Text('End Time: ${job['end_time']}'),
            Text('Robot ID: ${job['id_robot']}'),
          ],
        ),
      ),
    );
  }
}
