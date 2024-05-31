import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'job_class.dart';
import '../robots/robot_class.dart';
import 'actual.dart';
import '../globals.dart';
import '../functions/job_requests.dart';

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
        color: Colors.green.shade100, // Fondo de la pantalla verde
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Rectángulo blanco
                borderRadius: BorderRadius.circular(20.0), // Esquinas redondeadas
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Job Information',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Text('Cutting Height: ${globalJob!.cutting_height}'),
                  Text('Area: ${globalJob!.area}'),
                ],
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
                      color: i == 3 ? Colors.white : Colors.green.shade600, // El punto al final estará resaltado
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                globalJob!.start_time = DateTime.now();
                globalJob!.state = "active";
                globalJob!.model = "¡¡¡DELETE THIS INITIALIZATION!!!"; // TO UPLOAD THIS DOESN'T MAKE SENSE!
                globalJob!.end_time = DateTime.now(); // TO UPLOAD THIS AT INITIALIZATION DOESN'T MAKE SENSE!
                print("Global Job area: ${globalJob!.area}");
                int? id_job = await add_job(globalJob!);

                if (id_job != null) {
                  globalJob!.id = id_job;
                  globalRobot!.id_active_job = id_job;

                  if (context.mounted) {
                    context.goNamed("actual");
                  }
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ActualJobPage(),
                    ),
                  );*/
                }
                else print("Error: job not added at DB");
              },
              child: const Text('Start job'),
            )
          ],
        ),
      ),
    );
  }
}
