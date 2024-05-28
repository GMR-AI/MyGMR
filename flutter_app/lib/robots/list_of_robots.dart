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
                  imageUrl: 'https://fffe6984a14061ec4e177cafe7d290a3e2fdf769767edad2b3fe52b-apidata.googleusercontent.com/download/storage/v1/b/gmr-ai-user-images/o/test.jpg?jk=ASOpP9jzKPzM6XbB5vWuCLraPSQhD-vayRuEW4ZnLWKebC5YNEwDtm6HCapMQ8E3fH8vYxkKTOElvZNf_D2PQHzcKemThxbKlZ5NjiN-_53CAgxZgmcMQ3KhI2W5GOOY2RNJoHV1XHgr3mji3GEeETEpEg-Z-aPagEl-ua3XJKmpnDkyF44H0uiRATd08KrcuYUpJfsbp2WvhXaaend56PEliUMLhuPc6jub8doz2o08NyE2UXw2CfJ19tjOyKQuZpLp-DcrcSvy1uo8PVsUebVQMW6lfHBKy1dWk16reKIdNU6JtO_BZQ8hDu2UD6SHMxwE3PyQRrQIn23a030uCMWWLTewAjBrxypKx-U1k_pwAa8bWk-Jgnz94m-ZGMoC6bM0RWwwc_s6AaWQges6Vx9kt3bi5j0Gbp1l_057KEJPpr6bH0msbV9POiCI2opTs8MWIdmpDQGjSD1iV4D4eTSZmnX3t0qXSLVg0m_RQOI3pc5b6YdlcaI6m6snvpwd0yTTFKVMy53VyRiJI4C1ckvIqrOgglEKXhJ-aIqD5zJwckArvC1SLrjbXWwFfvc8Nw2BBG-EqZ-f-RmZLxZzm_U9cBPame0XHyXb1TikWt92j9Q_YEwLyd6R65PAA1RX2U7_Q_r-lni6p8lFP1tXvB1utj6fPaZWVhnbGNxncU1Hw546lZOQk0Zbaq4kyEo1wtpF-c5tXmZ2CS15CzwTjD6znxxtVc0cxen3OC4ItJ5l9zrpreh9sC2wvnjZSQAZIaOeT8MiMG0OFn-qhUpaMzGWw5q8kUplJTVchKi_uHpqpLJVHkRSCHCqQKhPQdGKVT8iT_5yvUmG-HmXxE02fHcnVZKR_THyCFYlLiOgZLjg1kPdBBVlqIUkWvQEVncWy06yJpxyf6jN0E7PNdDb57nGqF7XatabNO3nfoNLwhg6M42_lxO2FHQTf8mF_mvIB7JftVmoi9WwCMCRrL76NF8otyFK3ngLlPVhU96e5SDSz2GF8UCd6xIgGgxMdoQOyqmRYGUMBbILBALnyI_l_1YwBi0KtDe6Y2i6RbI50pNOPTt3dWOtU35-TEi0_ZXHLJ8wZJnH3Du_QahnCJscNGeMdsb-Fd9FCEmUXYcFeREVFnbm8eZUJ-4QVQA-6lUgaYZ-iDQtO5XNtRdoCkMGQYtbfOY&isca=1' ?? '',
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