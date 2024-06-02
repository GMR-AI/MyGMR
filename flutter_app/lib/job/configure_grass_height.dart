import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../globals.dart';

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
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotatedBox(
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
          Positioned(
            top: 15.0,
            left: 55.0,
            child: Text(
              '10',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: value == 3 ? Colors.green : Colors.grey,
              ),
            ),
          ),
          Positioned(
            top: height * 0.35 - 8.0,
            left: 60.0,
            child: Text(
              '8',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: value == 2 ? Colors.green : Colors.grey,
              ),
            ),
          ),
          Positioned(
            top: height * 0.60 - 8.0,
            left: 60.0,
            child: Text(
              '4',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: value == 1 ? Colors.green : Colors.grey,
              ),
            ),
          ),
          Positioned(
            top: height * 0.85 - 8.0,
            left: 60.0,
            child: Text(
              '2',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: value == 0 ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfigureGrassHeightPage extends StatefulWidget {
  ConfigureGrassHeightPage();

  @override
  _ConfigureGrassHeightPageState createState() => _ConfigureGrassHeightPageState();
}

class _ConfigureGrassHeightPageState extends State<ConfigureGrassHeightPage> {
  int _grassHeightIndex = 0; // Índice inicial de la altura del césped

  // Lista de alturas correspondientes a cada posición de la barra deslizante
  final List<int> _heightValues = [2, 4, 8, 10];

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
    if (globalJob == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Step 1'),
        ),
        body: const Center(
          child: Text('No job available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            globalJob = null;
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Configure Grass Height (cm)',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 6, // La imagen ocupará 5 partes de 6
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0), // Añade padding a la derecha para mover la barra
                          child: Image.asset(
                            _imagePaths[_grassHeightIndex],
                            height: 200.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2, // La barra deslizante ocupará 1 parte de 6
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
                      color: _currentPage == i ? Colors.white : Colors.green.shade600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                globalJob!.cutting_height = _heightValues[_grassHeightIndex];
                context.goNamed("define_area");
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DefineAreaPage()),
                );*/
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
