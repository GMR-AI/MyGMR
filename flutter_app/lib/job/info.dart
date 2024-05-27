import 'package:flutter/material.dart';

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
            Text('State: ${job['state']}'),
            Text('Start Time: ${job['start_time']}'),
            Text('End Time: ${job['end_time']}'),
            Text('Robot ID: ${job['id_robot']}'),
          ],
        ),
      ),
    );
  }
}
