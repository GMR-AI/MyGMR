import 'package:flutter/material.dart';
import '../globals.dart';
import '../main_robot.dart';
import 'robot_class.dart';
import 'add_robot.dart';
import 'no_robots.dart';
import '../functions/robots_requests.dart';
import 'package:cached_network_image/cached_network_image.dart';

Color backgroundColor = Color(0xFFEFEFEF);

class ListOfRobots extends StatefulWidget {
  const ListOfRobots({super.key});

  @override
  State<ListOfRobots> createState() => _ListOfRobotsScreen();
}

class _ListOfRobotsScreen extends State<ListOfRobots> {
  //List<Robot> _robots = [
  //  Robot(id: 0, name: 'Robot 1', img: 'assets/robot_design.png'),
  //  Robot(id: 1, name: 'Robot 2', img: 'assets/robot_design.png'),
  //];
  List<Robot> _robots=[];
  bool _isLoading = true;
  bool _showConfirmationDialog = false;

  @override
  void initState() {
  super.initState();
  _fetchRobots();
  }

  Future<void> _fetchRobots() async {
    List<Robot>? robots = await get_robots();

    setState(() {
    _robots = robots!=null ? robots : [];
    _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Robots'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_robots.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NoRobots()),
        );
      });
    }
    List<Widget> robotWidgets = List.generate(_robots.length, (index) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            globalRobot = _robots[index];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainRobot(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: _robots[index].img ?? '',
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) =>
                      Image.asset(
                        'assets/robot_design.png',
                        height: 50.0,
                        width: 50.0,
                      ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    _robots[index].name ?? 'No name',
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
      );    });

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