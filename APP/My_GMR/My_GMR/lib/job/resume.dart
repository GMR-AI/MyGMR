import 'package:flutter/material.dart';
import 'job_class.dart';

class ResumePage extends StatelessWidget {
  final Job job; // Declara una propiedad para almacenar la instancia de Job

  // Constructor que acepta una instancia de Job
  const ResumePage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Text('Date: ${job.date}'),
                  Text('Cutting Height: ${job.cuttingHeight}'),
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
              onPressed: () {
                // Aquí podrías iniciar el trabajo o realizar alguna acción relacionada
              },
              child: Text('Start job'),
            ),
          ],
        ),
      ),
    );
  }
}
