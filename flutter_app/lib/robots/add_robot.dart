import 'package:flutter/material.dart';
import 'package:my_gmr/robots/robot_class.dart';
import '../robots/list_of_robots.dart';
import '../robots_requests.dart';

Color backgroundColor = Color(0xFFEFEFEF);

class AddRobot extends StatefulWidget {
  const AddRobot({super.key});

  @override
  State<AddRobot> createState() => _AddRobotScreen();
}

class _AddRobotScreen extends State<AddRobot> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  bool _showSaveButton = true;
  dynamic _data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new robot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your robot ID:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _controller,
              maxLength: 8,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Type here',
                border: OutlineInputBorder(),
                counterText: '',
                errorText: _errorText,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'Where can I find my robot ID?',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 10.0),
                Tooltip(
                  message: 'More Info',
                  child: IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      // Lógica para mostrar la ventana emergente con la imagen
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Image.asset('assets/info_robot_id.png'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Got it!'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Center(
              child: Visibility(
                visible: !_showSaveButton, // Mostrar solo si el botón "Save" está oculto
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _data is String ? _data : 'Robot saved successfully!',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para conectar con el robot
                        if (_data is! String){
                          // TODO: Preprocess data
                          robot_list.add(Robot(_data))
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ListOfRobots()),
                        );
                      },
                      child: Text(_data is String ? 'Connect with my robot' : 'Go Back'),
                    ),
                  ],
                ),
              ),
            ),
            if (_showSaveButton)
              ElevatedButton(
                onPressed: () {
                  final String? value = _controller.text.trim();
                  if (value != null && value.isNotEmpty) {
                    if (value.length == 8 && int.tryParse(value) != null) {
                      setState(() {
                        _data = push_and_get_robots(context, value);
                        _errorText = null;
                        _showSaveButton = false; // Ocultar el botón "Save"
                      });
                    } else {
                      setState(() {
                        _errorText = 'Must be an 8 digit number';
                      });
                    }
                  } else {
                    setState(() {
                      _errorText = 'Please enter a value';
                    });
                  }
                },
                child: Text('Save'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



