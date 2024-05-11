import 'package:flutter/material.dart';
import 'job_class.dart';
import 'resume.dart';

class DefineAreaPage extends StatefulWidget {
  final Job job; // Declara una propiedad para almacenar la instancia de Job

  // Constructor que acepta una instancia de Job
  const DefineAreaPage({Key? key, required this.job}) : super(key: key);

  @override
  _DefineAreaPageState createState() => _DefineAreaPageState();
}

class _DefineAreaPageState extends State<DefineAreaPage> {
  final TextEditingController _areaController = TextEditingController(); // Controlador para el campo de texto
  double _area = 0.0; // Variable para guardar el área deseada
  bool _isValid = true; // Variable para controlar si el valor ingresado es válido

  @override
  void dispose() {
    _areaController.dispose(); // Liberar recursos del controlador al eliminar la página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step 2'),
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
                    'Defines the cutting area',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Image.asset(
                    'assets/area.png', // Ruta de la imagen
                    width: 200.0, // Ancho de la imagen
                    height: 200.0, // Alto de la imagen
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(
                labelText: 'Enter area', // Etiqueta del campo de texto
                border: OutlineInputBorder(), // Borde del campo de texto
                errorText: _isValid ? null : 'Invalid value', // Texto de error si el valor es inválido
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true), // Teclado numérico
              onChanged: (value) {
                final double? newValue = double.tryParse(value);
                setState(() {
                  _isValid = newValue != null; // Verifica si el valor es válido
                  if (_isValid) {
                    _area = newValue!;
                  }
                });
              },
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
                      color: i == 2 ? Colors.white : Colors.green.shade600, // El punto central estará resaltado
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isValid
                  ? () {
                widget.job.area = _area; // Guarda el valor del área en el objeto Job
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResumePage(job: widget.job)),
                );
              }
                  : null, // Deshabilita el botón si el valor ingresado es inválido
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
