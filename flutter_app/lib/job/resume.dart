import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'job_class.dart';
import '../robots/robot_class.dart';
import 'actual.dart';
import '../globals.dart';
import '../functions/job_requests.dart';

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

class ResumePage extends StatelessWidget {
  ResumePage();

  @override
  Widget build(BuildContext context) {
    if (globalJob == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Resume'),
        ),
        body: const Center(
          child: Text('No job available'),
        ),
      );
    }

    List<String> formattedPoints = globalJob!.area!.entries.map((entry) {
      String index = entry.key;
      List<double> point = entry.value;
      return 'Point ${int.parse(index) + 1}: (${point[0]}, ${point[1]})';
    }).toList();
    print(formattedPoints);
    String formattedText = formattedPoints.join('\n');
    print(formattedText);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            globalJob!.area = null;
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.green.shade100,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Job Information',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _buildInfoRow('Cutting Height', '${globalJob!.cutting_height} cm'),
                    _buildInfoRow('Area', formattedText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 3; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == 3 ? Colors.white : Colors.green.shade600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                globalJob!.start_time = DateTime.now();
                print("Global Job area: ${globalJob!.area}");
                int? id_job = await add_job(globalJob!);

                if (id_job != null) {
                  globalJob!.id = id_job;
                  globalRobot!.id_active_job = id_job;

                  if (context.mounted) {
                    context.goNamed("actual");
                  }
                } else {
                  print("Error: job not added at DB");
                }
              },
              child: const Text('Start Job'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
