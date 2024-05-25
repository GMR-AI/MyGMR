import 'package:flutter/material.dart';
import 'info.dart';

class ListOfJobs extends StatelessWidget {
  final List<dynamic> jobs;

  ListOfJobs({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Jobs'),
      ),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return ListTile(
            title: Text(job['name']),
            subtitle: Text(job['state']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobInfo(job: job),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
