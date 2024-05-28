import 'package:flutter/material.dart';
import 'job_class.dart';
import '../robots/robot_class.dart';
import 'actual.dart';
import '../globals.dart';
import '../functions/job_requests.dart';

class ResumePage extends StatelessWidget {
  ResumePage();

  @override
  Widget build(BuildContext context) {
    Job? job = globalJob; // Obtener la instancia de Job global

    if (job == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Resume'),
        ),
        body: Center(
          child: Text('No job available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Resume'),
      ),
      body: Container(
        color: Colors.green.shade100, // Fondo de la pantalla verde
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Rectángulo blanco
                borderRadius: BorderRadius.circular(20.0), // Esquinas redondeadas
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Job Information',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text('Date: ${job.start_time}'),
                  Text('Cutting Height: ${job.cutting_height}'),
                  Text('Area: ${job.area}'),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 3; i++)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == 3 ? Colors.white : Colors.green.shade600, // El punto al final estará resaltado
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                int? id_job = await add_job(job);

                if (id_job != null) {
                  job.id = id_job;
                  globalJob = job;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActualJobPage(),
                    ),
                  );
                }
                else print("Error: job not added at BD");
              },
              child: Text('Start job'),
            )
          ],
        ),
      ),
    );
  }
}
