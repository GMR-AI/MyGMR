import 'package:flutter/material.dart';
import 'define_area.dart';
import 'job_class.dart';

class VerticalSlider extends StatelessWidget {
  final double height;
  final int value;
  final ValueChanged<int> onChanged;

  VerticalSlider({
    required this.height,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RotatedBox(
        quarterTurns: 3,
        child: Slider(
          value: value.toDouble(),
          min: 0,
          max: 3,
          divisions: 3,
          onChanged: (double newValue) {
            onChanged(newValue.toInt());
          },
        ),
      ),
    );
  }
}

class ConfigureGrassHeightPage extends StatefulWidget {
  final Job job; // Define a field to hold the Job instance

  // Constructor to receive the Job instance
  const ConfigureGrassHeightPage({Key? key, required this.job}) : super(key: key);

  @override
  _ConfigureGrassHeightPageState createState() => _ConfigureGrassHeightPageState();
}

class _ConfigureGrassHeightPageState extends State<ConfigureGrassHeightPage> {
  int _grassHeightIndex = 0; // Índice inicial de la altura del césped

  // Lista de alturas correspondientes a cada posición de la barra deslizante
  final List<double> _heightValues = [2, 4, 8, 10];

  // Lista de rutas de imágenes correspondientes a cada altura de la barra deslizante
  final List<String> _imagePaths = [
    'assets/grass/g_2.png',
    'assets/grass/g_4.png',
    'assets/grass/g_8.png',
    'assets/grass/g_10.png',
  ];

  int _currentPage = 1; // Página actual

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step 1'),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Configure Grass Height',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 5, // La imagen ocupará 5 partes de 6
                        child: Image.asset(
                          _imagePaths[_grassHeightIndex],
                          height: 200.0,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        flex: 1, // La barra deslizante ocupará 1 parte de 6
                        child: VerticalSlider(
                          height: 200,
                          value: _grassHeightIndex,
                          onChanged: (newValue) {
                            setState(() {
                              _grassHeightIndex = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
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
                      color: _currentPage == i ? Colors.white : Colors.green.shade600,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                widget.job.cuttingHeight = _heightValues[_grassHeightIndex];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DefineAreaPage(job: widget.job)),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
