import 'package:flutter/material.dart';
import 'package:my_gmr/globals.dart';
import 'info.dart';
import 'job_class.dart';
import '../functions/job_requests.dart';

class ListOfJobs extends StatelessWidget {
  List<Job>? jobs;

  ListOfJobs({this.jobs});

  @override
  Widget build(BuildContext context) {
    if (jobs == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('List of Jobs'),
        ),
        body: const Center(
          child: Text('No previous jobs yet'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Jobs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: jobs!.length,
              itemBuilder: (context, index) {
                final job = jobs![index];
                return ListTile(
                  title: Text("Job: ${job.start_time}"),
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
                Navigator.pop(context);
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                if (globalRobot != null) {
                  await delete_jobs(globalRobot!.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }
}

