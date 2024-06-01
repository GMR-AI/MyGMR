import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../globals.dart';
import '../main_robot.dart';
import 'robot_class.dart';
import 'add_robot.dart';
import 'no_robots.dart';
import '../functions/robots_requests.dart';
import 'package:cached_network_image/cached_network_image.dart';

Color backgroundColor = const Color(0xFFEFEFEF);

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
  int? _selectedRobotId;
  int? _selectedRobotCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRobots();
    });
  }

  Future<void> _fetchRobots() async {
    List<Robot>? robots = await get_robots();
    setState(() {
      _isLoading = false;
      _robots = robots ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Robots'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_robots.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed("no_robots");
        }
      });
    }
    List<Widget> robotWidgets = List.generate(_robots.length, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            _showConfirmationDialog = false;
            globalRobot = _robots[index];
            context.goNamed("main_robot");
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainRobot(),
              ),
            );*/
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
                const SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    _robots[index].name ?? 'No name',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _selectedRobotId = _robots[index].id;
                      _selectedRobotCode = _robots[index].id_connect;
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
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRobot()),
            );
          },
          child: const Row(
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
        title: const Text('My Robots'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
      title: const Text('Delete this robot?'),
      actions: [
        TextButton(
          onPressed: () async {
            if (_selectedRobotId != null) {
              await delete_this_robot(_selectedRobotId!, _selectedRobotCode!);
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {
                  _robots.removeWhere((robot) => robot.id == _selectedRobotId);
                  _showConfirmationDialog = false;
                  _selectedRobotId = null;
                  _selectedRobotCode = null;
                });
              }
            }
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showConfirmationDialog = false;
            });
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}