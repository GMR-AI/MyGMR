import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'functions/user_requests.dart';

Color backgroundColor = Color(0xFFEFEFEF);



class Welcome extends StatefulWidget {
  const Welcome({super.key, required this.title});
  final String title;

  @override
  State<Welcome> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<Welcome> {
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onVerticalDragUpdate: (details) async {
          setState(() {
            _scrollPosition += details.primaryDelta!;
          });
          if (_scrollPosition < -20) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SignUp(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            }
        },
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/robot_design.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: _scrollPosition < -20 ? 100.0 : 0.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.0), // Transparente
                      Colors.white.withOpacity(0.5), // Opacidad gradual
                    ],
                  ),
                ),
                child: Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo_png.png',
                      width: 60.0,
                      height: 60.0,
                    ),
                    Text(
                      'MyGMR',
                      style: TextStyle(
                        fontFamily: 'Logo',
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to MyGMR',
                      style: TextStyle(
                        fontFamily: 'Logo',
                        fontSize: 35.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40.0,
              left: 0,
              right: 0,
              child: Center(
                child: Icon(Icons.arrow_upward, size: 40.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

  }

}





