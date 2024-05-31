import 'package:flutter/material.dart';
import 'package:my_gmr/globals.dart';
import 'info.dart';
import 'job_class.dart';
import '../functions/job_requests.dart';
import '../robots/robot_class.dart';

class ListOfJobs extends StatelessWidget {
  final List<Job> jobs;

  ListOfJobs({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Jobs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return ListTile(
                  title: Text(job.start_time!.day.toString()),
                  subtitle: Text(job.state.toString()),
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
          ),
          ElevatedButton.icon(
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Delete All Jobs'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete All Jobs"),
          content: const Text("Are you sure you want to delete all jobs?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                Robot? robot = globalRobot;
                if (robot != null) {
                  int rid = robot.id;
                  await delete_jobs(rid);
                  Navigator.of(context).pop();
                }
                else print("Error: no robot detected");
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }
}

