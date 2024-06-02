import 'package:flutter/material.dart';
import 'package:my_gmr/globals.dart';
import 'job_class.dart';

class Point {
  final double dx;
  final double dy;

  Point(this.dx, this.dy);

  factory Point.fromMap(Map<String, dynamic> map) {
    return Point(map['dx'], map['dy']);
  }
}

extension JobExtensions on Job {
  List<Point> get points {
    if (area != null && area!['points'] != null) {
      return (area!['points'] as List<dynamic>)
          .map((pointMap) => Point.fromMap(pointMap as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}

class JobInfo extends StatelessWidget {
  final Job job;

  JobInfo({required this.job});

  @override
  Widget build(BuildContext context) {
    List<String> formattedPoints = job.points.asMap().entries.map((entry) {
      int index = entry.key;
      Point point = entry.value;
      return 'Point ${index + 1}: (${point.dx}, ${point.dy})';
    }).toList();
    String formattedText = formattedPoints.join('\n');

    return Scaffold(
      appBar: AppBar(
        title: Text("Job ${job.id.toString()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoCard('Cutting Height', '${job.cutting_height ?? 'N/A'} cm'),
            _buildInfoCard('Area', formattedText),
            _buildInfoCard('Start Time', job.start_time?.toString() ?? 'N/A'),
            _buildInfoCard('End Time', job.end_time?.toString() ?? 'N/A'),
            if (job.start_time != null && job.end_time != null)
              _buildInfoCard(
                  'Elapsed Time', job.end_time!.difference(job.start_time!).toString()),
            _buildInfoCard('Robot ID', job.id_robot.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
