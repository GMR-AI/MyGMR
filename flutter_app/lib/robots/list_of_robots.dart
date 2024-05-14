import 'package:flutter/material.dart';
import '../home.dart';
import 'robot_class.dart';
import '../robots/add_robot.dart';

Color backgroundColor = Color(0xFFEFEFEF);

class ListOfRobots extends StatefulWidget {
  const ListOfRobots({super.key});

  @override
  State<ListOfRobots> createState() => _ListOfRobotsScreen();
}

class _ListOfRobotsScreen extends State<ListOfRobots> {
  List<Robot> _robots = [
    Robot('Robot 1', 'assets/robot_design.png'),
    Robot('Robot 2', 'assets/robot_design.png'),
    // Agrega más robots aquí si es necesario
  ];

  bool _showConfirmationDialog = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> robotWidgets = List.generate(_robots.length, (index) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(robot: _robots[index]),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  _robots[index].imagePath,
                  height: 50.0,
                  width: 50.0,
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    _robots[index].name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _showConfirmationDialog = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });

    robotWidgets.add(
      Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRobot()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Robots'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: robotWidgets,
          ),
          if (_showConfirmationDialog)
            _buildConfirmationDialog(context),
        ],
      )
    );
  }

  Widget _buildConfirmationDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Delete this robot?'),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _showConfirmationDialog = false;
            });
            // Perform delete action here
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showConfirmationDialog = false;
            });
          },
          child: Text('No'),
        ),
      ],
    );
  }
}