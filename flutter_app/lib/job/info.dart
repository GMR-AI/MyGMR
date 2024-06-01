import 'package:flutter/material.dart';
import 'package:my_gmr/globals.dart';

import 'job_class.dart';
class JobInfo extends StatelessWidget {
  final Job job;

  JobInfo({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job ${job.id.toString()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cutting Height: ${job.cutting_height}'),
            Text('Area: ${job.area}'),
            Text('Start Time: ${job.start_time!.toString()}'),
            Text('End Time: ${job.end_time!.toString()}'),
            Text("Elapsed time; ${job.end_time!.difference(job.start_time!).toString()}"),
            Text('Robot ID: ${job.id_robot}'),
          ],
        ),
      ),
    );
  }
}
