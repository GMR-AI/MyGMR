import 'package:flutter/material.dart';
import 'robots/robot_class.dart';
import 'users/user_class.dart';
import 'robots/home_robot.dart';
import 'users/user_profile.dart';

Color backgroundColor = Color(0xFFEFEFEF);

class MainRobot extends StatefulWidget {
  final Robot robot;
  MainRobot({required this.robot});

  @override
  _MainRobotState createState() => _MainRobotState();
}

class _MainRobotState extends State<MainRobot> {
  int _selectedIndex = 0;
  User _user = getUser();

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Home(robot: widget.robot),
      UserProfile(user: _user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
